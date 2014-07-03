'play!file.jpg - plays file.jpg
'play!folder!myfoldername - plays files in myfoldername
'play!transtion!15 - enables fade transition



'only tested with image playback so far 4-1-14

Function play_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "play_Initialize - entry"
    play = newplay(msgPort, userVariables, bsp)
	play.startscreentimer()
	
    return play

End Function


Function newplay(msgPort As Object, userVariables As Object, bsp as Object)
	print "newplay"

	s = {}
	s.version = 1.9
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = play_ProcessEvent
	s.dlog = dlog
	s.playimage = play_playimage
	s.playvideo = play_playvideo
	s.playfile = play_playfile
	s.playfolder = play_playfolder	'video only currently
	s.startmytimer = play_startmytimer
	s.startscreentimer = play_startscreentimer
	s.capturescreen = play_capturescreen
	s.playlist = false
	s.loop = false
	s.vclear = true
	s.iclear = false
	s.floop= false
	s.transition = 20	'fade is 15
	s.randomtransition = false
	s.folder$ = "/"
	s.imagetime% = 5
	s.objectName = "play_object"
	s.debug  = true

	s.udpReceiverPort = 555
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)


	return s
	
End Function


Function play_ProcessEvent(event As Object) as boolean
	'm.bsp.diagnostics.printdebug("Processing play plugin events")
	retval = false

	if type(event) = "roAssociativeArray" then

        	if type(event["EventType"]) = "roString" then
             		if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                		if event["PluginName"] = "play" then
                    		pluginMessage$ = event["PluginMessage"]
							print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
							'messageToParse$ = event["PluginName"]+"!"+pluginMessage$
							m.dlog("Plugin Message: "+pluginMessage$)
							retval = ParseplayPluginMsg(pluginMessage$, m)
					
                		endif
            		endif
        	endif
		
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		m.dlog("UDP plugin event: "+msg$)
		if (left(msg$,4) = "play") then
		    retval = ParseplayPluginMsg(msg$, m)
		end if

	else if (type(event) = "roUrlEvent") then
		'm.bsp.diagnostics.printdebug("play_plugin Url Event")
		
	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then
		'm.dlog("play_plugin Timer Event")
		if m.imagetimer <> invalid then 
		
			if event.GetSourceIdentity() = m.imagetimer.GetIdentity() then

				if m.playlist then
					m.playfolder(m.folder$)
				
				else
					if m.imagetimer <> invalid then m.imagetimer.stop()			
					if m.iplayer <> invalid then m.iplayer.StopDisplay()		
					m.dlog("play plugin, image timer")
				endif
				
			endif
		endif
		
		if m.screentimer <> invalid then 
			if event.GetSourceIdentity() = m.screentimer.GetIdentity() then
				m.dlog("Screen timer event, play plugin")
				m.capturescreen()
				m.startscreentimer()
				
			endif		
		endif

	else if type(event) = "roVideoEvent" and event.GetInt() = 8 then
	
		if m.vplayer <> invalid then
					
			if event.GetSourceIdentity() = m.vplayer.GetIdentity() then 
				if m.playlist then
					m.playfolder(m.folder$)
				
				else
					m.playlist=false
					
					if m.vclear then 
						m.vplayer.StopClear()
					else if m.loop then 
						m.vplayer.playfile()
					else
						m.vplayer.stop()
					endif
				endif
			else
				m.dlog ("play plugin, not our video player's event")
				
			endif
			
		endif
		
		
	end if

	return retval

End Function



Function ParseplayPluginMsg(origMsg as string, s as object) as boolean
	retval  = false
	command = " "
	param=" "
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^play", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if numFields > 3 then
			s.dlog("Incorrect number of fields for play command:"+origMsg)
			return retval
		else if numFields = 3 then			
			command = fields[1]
			param = fields[2]
			m.playlist = false	'new 4-1-14
		

		else if (numFields = 2) then
			print "Two Fields found"
			
			command=fields[1]
			
			If command = "showme" then
				s.startscreentimer()
			else if command = "noscreen" then
				if s.screentimer <> invalid then s.screentimer.stop()
				
			else if command = "floop" then
				s.floop = true
			else if command = "nofloop" then
				s.floop = false
				
			else
				s.folder$ = "/"
				s.currentfile$ = command
			endif
			
		end if
	end if

	s.dlog("command found: " +command)

	if command = "debug" then
		s.dlog("Debug Enabled")
	    	s.debug=true
	else if command = "reboot" then
		s.dlog("Rebooting")
	    	rebootsystem()
			
	else if command = "folder" then
		if s.iplayer <> invalid then s.iplayer.stopdisplay() 'new
		if s.imagetimer <> invalid then s.imagetimer.stop() 'new
		
		s.folder$ = param
		s.playfolder(s.folder$)	

	else if command = "transition" then 
		s.transition = val(param)	'transition value

	else if command = "stop" then 
		if s.iplayer <> invalid then s.iplayer.stopdisplay()
		if s.vplayer <> invalid then s.vplayer.stopclear()
		
	else if command <> " " then
		if s.iplayer <> invalid then s.iplayer.stopdisplay() 'new
		if s.vplayer <> invalid then s.vplayer.stopclear() 'newer
		if m.playlist <> invalid then m.playlist = false 'newer
		
		s.playfile()

	endif
	
	return retval
end Function


Sub play_playimage()
	m.dlog("Play Image Sub")
	if type(m.iplayer) <> "roImagePlayer" then m.iplayer = createobject("roImagePlayer")
	m.iplayer.setdefaultmode(3) 'scale to fill
	m.iplayer.setdefaulttransition(m.transition)	'new 4-1-14
	ok = m.iplayer.Displayfile("/"+m.folder$+"/"+m.currentfile$)
	print "playback status:"; ok
	print m.currentfile$; " is current file setting."
		
	if ok = 0 then m.iplayer.Displayfile(GetPoolFilePath(m.bsp.syncPoolFiles, m.currentfile$))

	m.startmytimer()

end Sub

Sub play_playvideo()
	m.dlog("Play Video sub")
	if type(m.vplayer) <> "roVideoPlayer" then m.vplayer = createobject("roVideoPlayer")
	m.vplayer.setport(m.msgport)
	ok = m.vplayer.Playfile("/"+m.folder$+"/"+m.currentfile$)
	if ok = 0 then m.vplayer.playfile(GetPoolFilePath(m.bsp.syncPoolFiles, m.currentfile$))

end Sub


Sub dlog (error$ as String)
	'm.bsp.logging.WriteDiagnosticLogEntry("99plgn", error$)
	'm.bsp.diagnostics.printdebug(error$)
	print error$
End Sub




Function GetFileType(file As String) as String
	file = ucase(file)
	
	if right(file,3)="MP4" or right(file,3)="WMV" or right(file,3)="MOV" or right(file,3)="VOB" or right(file,3)="MPG" or right(file,2)="TS" then
		print "Play plugin, type video"
		return("VIDEO")
	else if right(file,3)="PNG" or right(file,3)="JPG" or right(file,3)="BMP" then
		print "Play plugin, type image"
		
		return("IMAGE")
	else if right(file,3)="MP3" or right(file,3)="WAV" then
		print "Play plugin, type audio"
		retrun("AUDIO")
	endif

	return("UNK")

End Function


Sub play_playfile ()
'm.dlog("Playfile plugin")
		if GetFileType(m.currentfile$) = "VIDEO" then
			m.playvideo()

		else if GetFileType(m.currentfile$) = "IMAGE" then
			m.playimage()

		else if GetFileType(m.currentfile$) = "UNK" then
			m.dlog("Unknown file type, Not Image or Video")
		endif

end sub


Sub play_playfolder(folder$ as string)
m.dlog(" Play Folder plugin")

	rescanfolder=false	'new - all items related
	if m.floop then
		'if looping is enabled, restart folder play when mylist is empty
		if m.playlist then
			if m.mylist.count() = 0 then rescanfolder=true
		endif
	endif
	
	if m.playlist= true and rescanfolder = false then
	
		if m.mylist.count() > 0 then
			m.currentfile$ = m.mylist.RemoveHead()
			m.playfile()
		else
			m.playlist = false
			' should I stop the timer here
			
			'clear image - end of folder playback
			m.iplayer.stopdisplay()	'new - may not be best here
			'assumes playing folder once
			
		endif

	else
		m.playlist = true
		m.mylist = listdir(folder$)
		if m.mylist.count() > 0 then
			m.currentfile$ = m.mylist.removehead()
			m.playfile()
			
		else
			m.dlog("No Files found in folder: "+folder$)
		endif

	endif

End Sub


Sub play_startmytimer()
m.dlog("Start My Timer sub")
	if type(m.imagetimer) <> "roTimer" then m.imagetimer = createobject("roTimer")
	m.imagetimer.Stop()
	newTimeout = m.bsp.systemTime.GetLocalDateTime()
	newTimeout.AddSeconds(m.imagetime%)
	m.imagetimer.SetDateTime(newTimeout)
	m.imagetimer.SetPort(m.msgPort)
	m.imagetimer.Start()
	

end Sub

Sub play_startscreentimer()
	m.dlog("Start Screen Time Sub")
	if type(m.screentimer) <> "roTimer" then m.screentimer = createobject("roTimer")
	m.screentimer.Stop()
	newTimeout = m.bsp.systemTime.GetLocalDateTime()
	newTimeout.AddSeconds(30)
	m.screentimer.SetDateTime(newTimeout)
	m.screentimer.SetPort(m.msgPort)
	m.screentimer.Start()
	
end Sub


Sub play_capturescreen()
m.dlog("capturescreen Sub")
	vm=CreateObject("roVideoMode")
	vm.SetPort(m.msgport)
	DeleteFile("sd:/screen.jpg")
	vm.Screenshot({filename:"sd:/screen.jpg", width:1280, height:720, filetype:"JPEG", async:0})
	
	
	'vm.Screenshot({filename:"usb1:/screen.jpg", width:1920, height:1080, quality:90, filetype:"JPEG", async:1})	

end sub






'todo
'add setting for number of times to loop
'add timer to rescan folder if sd card-folder can't be folder when folder scan is done


