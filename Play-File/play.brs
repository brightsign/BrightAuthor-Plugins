'play!filename
'play!folder!foldername


Function play_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "play_Initialize - entry"
    play = newplay(msgPort, userVariables, bsp)
    return play

End Function


Function newplay(msgPort As Object, userVariables As Object, bsp as Object)
	print "newplay"

	s = {}
	s.version = 0.2
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = play_ProcessEvent
	s.dlog = dlog
	s.playimage = playimage
	s.playvideo = playvideo
	s.playfile = playfile
	s.playfolder = playfolder	'video only currently
	s.startmytimer = startmytimer
	s.playlist = false
	s.loop = false
	s.vclear = true
	s.iclear = false
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
	m.bsp.diagnostics.printdebug("Processing play plugin events")
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
		'm.bsp.diagnostics.printdebug("play_plugin Timer Event")
		if event.GetSourceIdentity() = m.imagetimer.GetIdentity() then
			m.imagetimer.stop()
			m.iplayer.StopDisplay()			
		endif

	else if type(event) = "roVideoEvent" and event.GetInt() = 8 then
	
		if m.playlist then
			m.playfolder(m.folder$)
		
		else
			s.playlist=false
			if m.vclear then 
				m.vplayer.StopClear()
			else if m.loop then 
				m.vplayer.playfile()
			else
				m.vplayer.stop()
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
		

		else if (numFields = 2) then
			print "Two Fields found"
			s.folder$ = "/"
			command=fields[1]
			s.currentfile$ = command
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
		s.folder$ = param
		s.playfolder(s.folder$)	

	else if command <> " " then
		s.playfile()

	endif
	
	return retval
end Function


Sub playimage()
	if type(m.iplayer) <> "roImagePlayer" then m.iplayer = createobject("roImagePlayer")
	m.iplayer.setdefaultmode(3) 'scale to fill
	m.iplayer.Displayfile(m.currentfile$)
	m.startmytimer()

end Sub

Sub playvideo()
	if type(m.vplayer) <> "roVideoPlayer" then m.vplayer = createobject("roVideoPlayer")
	m.vplayer.setport(m.msgport)
	m.vplayer.Playfile(m.currentfile$)

end Sub


Sub dlog (error$ as String)
	m.bsp.logging.WriteDiagnosticLogEntry("99plgn", error$)
	m.bsp.diagnostics.printdebug(error$)
	print error$
End Sub




Function GetFileType(file As String) as String
	if right(file,3)="MP4" or right(file,3)="WMV" or right(file,3)="MOV" or right(file,3)="VOB" or right(file,3)="MPG" or right(file,2)="TS" then
		return("VIDEO")
	else if right(file,3)="PNG" or right(file,3)="JPG" or right(file,3)="BMP" then
		return("IMAGE")
	else if right(file,3)="MP3" or right(file,3)="WAV" then
		retrun("AUDIO")
	endif

	return("UNK")

End Function


Sub playfile ()

		if GetFileType(m.currentfile$) = "VIDEO" then
			m.playvideo()

		else if GetFileType(m.currentfile$) = "IMAGE" then
			m.playimage()

		else if GetFileType(file$) = "UNK" then
			m.dlog("Unknown file type, Not Image or Video")
		endif

end sub


Sub playfolder(folder$ as string)

	if m.playlist = true then
		m.currentfile$ = m.mylist.RemoveHead()
		m.playfile()

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


Sub startmytimer()

	if type(m.imagetimer) <> "roTimer" then m.imagetimer = createobject("roTimer")
	m.imagetimer.setport(m.msgport)
	m.imagetimer.SetElapsed(m.imagetime%,0)

end Sub
