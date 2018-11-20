
'ticker!scroll - turns on scroller
'ticker!message.txt - scrolls contents of message.txt file
'ticker!this is my message - scrolls the string "this is my message"


Function custom_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "custom_Initialize - entry"
    print "type of msgPort is ";type(msgPort)
    print "type of userVariables is ";type(userVariables)

    custom = newcustom(msgPort, userVariables, bsp)

    return custom

End Function


Function newcustom(msgPort As Object, userVariables As Object, bsp as Object)
	print "initcustom"

	' Create the object to return and set it up
	s = {}
	s.version = 1.13
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = custom_ProcessEvent
	s.settings$=""
	s.getsettings = custom_getsettings
	s.findwidget = custom_findwidget
	s.newscroll = ticker_newscroll
	s.objectName = "custom_object"
	s.mytickerbox = CreateObject("roRectangle",40,945,1840,100)	
	s.tickerx=-1
	s.tickery=-1
	s.tickerwidth=-1
	s.tickerheight=-1
	s.speed! = 1.0
	
	s.udpReceiverPort = 555
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)
	
	return s

End Function


Function custom_ProcessEvent(event As Object) as boolean
	retval = false
    print "custom_ProcessEvent - type of event is ";type(event)

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "custom" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    retval = ParsecustomPluginMsg(pluginMessage$, m)
                endif
            endif
        endif
	


	else if type(event) = "roDatagramEvent" then
			msg$ = event
			if (left(msg$,5) = "seek!") then
				retval = ParsecustomPluginMsg(msg$, m)
			end if

			if (left(msg$,7) = "ticker!") then
				retval = ParsecustomPluginMsg(msg$, m)
			end if


			if (left(msg$,7) = "rotate!") then
				retval = ParsecustomPluginMsg(msg$, m)
			end if
	
			if (left(msg$,5) = "fade!") then
				retval = ParsecustomPluginMsg(msg$, m)
			end if
			
			if (left(msg$,5) = "speed!") then
				retval = ParsecustomPluginMsg(msg$, m)
			end if

	else if type(event) = "roVideoEvent" then
		
			eventData = event.GetInt()
			
			if eventdata = 18 then 'end fade
				myevent$ = "ef"
				print "roVideoEvent, End Fade"
			
				pluginMessageCmd = CreateObject("roAssociativeArray")
				pluginMessageCmd["EventType"] = "EVENT_PLUGIN_MESSAGE"
				pluginMessageCmd["PluginName"] = "Custom"
				pluginMessageCmd["PluginMessage"] = myevent$
				m.msgPort.PostMessage(pluginMessageCmd)
			endif
	end if

	return retval

End Function

Function ParsecustomPluginMsg(origMsg as string, s as object) as boolean
	print "Parsing plugin message command"
	retval = false

	msg = origMsg
	print "Received Plugin message: " + msg
	
	' verify its a rotate message'
	r = CreateObject("roRegex", "^rotate", "i")
	rotate_match=r.IsMatch(msg)

	'verify if it's a seek message
	q = CreateObject("roRegex", "^seek", "i")
	seek_match=q.IsMatch(msg)

	'verify if it's a fade message
	o = CreateObject("roRegex", "^fade", "i")
	fade_match=o.IsMatch(msg)

	'verify if it's a ticker message
	w = CreateObject("roRegex", "^ticker", "i")
	ticker_match=w.IsMatch(msg)
	
	'verify if it's a speed message
	n = CreateObject("roRegex", "^speed", "i")
	speed_match=n.IsMatch(msg)	
	
	
	' Is this a rotate request
	if rotate_match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		
		if numFields = 3 then
			'expects rotate!zonename!setting
			zoneName$ = fields[1]
			param2 = fields[2]
			
			for each zone in s.bsp.sign.zonesHSM
				if lcase(zone.name$) = lcase(zoneName$) then
					print "Found Rotate Zone: "; zoneName$
					if s.getsettings(param2) then
						if zone.videoplayer <> invalid then zone.videoplayer.SetTransform(s.setting$)
						if zone.imageplayer <> invalid then zone.imageplayer.SetTransform(s.setting$)
					else
						if zone.videoplayer <> invalid then zone.videoplayer.SetTransform()
						if zone.imageplayer <> invalid then zone.imageplayer.SetTransform()
					endif

				endif
			next
		else if numFields = 2 then
			param = fields[1]
			for each zone in s.bsp.sign.zonesHSM
				if zone.videoplayer <> invalid then 
					if s.getsettings(param) then 
						if zone.videoplayer <> invalid then zone.videoplayer.SetTransform(s.setting$)
						if zone.imageplayer <> invalid then zone.imageplayer.SetTransform(s.setting$)
						exit for
					endif
				endif
			next
			
			'if s.getsettings(param) then s.bsp.sign.zoneshsm[0].videoplayer.SetTransform(s.setting$)
			
		endif
	
	else if speed_match then	'speed up or slowdown video
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		tspeed! = 5.0
		
		if numFields = 3 then
			'expects speed!zone!setting
			zoneName$ = fields[1]
			
			if type(fields[2].tofloat()) = "Float" then tspeed! = fields[2].tofloat()
			s.speed! = tspeed!
			for each zone in s.bsp.sign.zonesHSM
				if lcase(zone.name$) = lcase(zoneName$) then
					print "Found Speed Zone: "; zonename$
					zone.videoPlayer.SetPlaybackSpeed(s.speed!)
				endif
			next
			
		else if numFields = 2 then
			'expects speed!setting	'1.0 normal, 1.5 - 1.5x playback speed
			
			if type(fields[1].tofloat()) = "Float" then tspeed! = fields[1].tofloat()
			print type(fields[1].tofloat())
			s.speed! = tspeed!
			
			print "speed: ";s.speed!
			for each zone in s.bsp.sign.zonesHSM
				if zone.videoplayer <> invalid then 
					zone.videoplayer.SetPlaybackSpeed(s.speed!)
					exit for
				endif
			next
			
			's.bsp.sign.zoneshsm[0].videoplayer.Seek(param2)
		endif
		
	else if seek_match then	'seek request
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		
		
		if numFields = 3 then
			'expects seek!zonename!timeinmilliseconds
			'or seek!zonename!+/-offsetinmilliseconds

			print "3 Fields"
			' Get first char of the seek value
			prefix$ = Left(fields[2],1)
			zoneName$ = fields[1]
			param2 = int(val(fields[2]))
			for each zone in s.bsp.sign.zonesHSM
				if lcase(zone.name$) = lcase(zoneName$) then
					print "Found Seek Zone: "; zonename$
					if prefix$ = "+" then
					    'Seek forward by n millisec
					    amount = int(val(mid(fields[2], 2)))
					    curPos = zone.videoPlayer.GetPlaybackPosition()
					    endPos = zone.videoPlayer.GetDuration()
					    if curPos + amount > endPos then
						'avoid seeking past end of video
						newPos = endPos
					    else
						newPos = curPos + amount
					    endif
					    zone.videoPlayer.Seek(newPos)
					else if prefix$ = "-" then
					    'Seek backward by n millisec
					    amount = int(val(mid(fields[2], 2)))
					    curPos = zone.videoPlayer.GetPlaybackPosition()
					    if curPos < amount then
						'avoid seeking before start of video
						newPos = 0
					    else
						newPos = curPos - amount
					    endif
					    zone.videoPlayer.Seek(newPos)
					else
					    'Seek to arbitrary position
					    zone.videoPlayer.Seek(param2)
					endif
				endif
			next
			
		else if numFields = 2 then
			param2 = int(val(fields[1]))
			
			for each zone in s.bsp.sign.zonesHSM
				if zone.videoplayer <> invalid then 
					zone.videoplayer.Seek(param2)
					exit for
				endif
			next
			
			's.bsp.sign.zoneshsm[0].videoplayer.Seek(param2)
		endif


	else if fade_match then	'fade request
		print "fade matched"
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
	
		if numFields = 2 then

			param2 = int(val(fields[1]))
			print "param2: ";param2			
			for each zone in s.bsp.sign.zonesHSM
				if zone.videoplayer <> invalid then
					aa=CreateObject("roAssociativeArray")
					aa["FadeOutLength"] = param2
					zone.videoplayer.SetFade(aa)
					exit for
				endif
			next

		else if numFields = 3 then
			'expects fade!zonename!setting

			print "3 Fields"
			zoneName$ = fields[1]
			param2 = int(val(fields[2]))
			
			for each zone in s.bsp.sign.zonesHSM
				if (lcase(zone.name$) = lcase(zoneName$)) then
					print "Found Fade Zone: "; zoneName$
					
					if zone.videoplayer <> invalid then
						aa=CreateObject("roAssociativeArray")
						aa["FadeOutLength"] = param2
						zone.videoplayer.SetFade(aa)
					else
						print "no Video Player in this zone:"; zoneName$
					endif

				endif
			next
			
		endif


	else if ticker_match then	'ticker request
		print "ticker matched"
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
	
		if numFields = 2 then
			print "2 fields"
			param = fields[1]
			print "param: ";param


			if lcase(param) = "scroll" then
			
					s.newscroll()
				    'if s.mytw <> invalid then s.mytw.Show()

			else if lcase(param) = "hide" then
				if s.mytw <> invalid then s.mytw.Hide()
			else if lcase(param) = "show" then
				if s.mytw <> invalid then s.mytw.Show()
			else if lcase(param) = "transparent" then
				if s.mytw <> invalid then s.mytw.SetBackgroundColor(0)
			else if lcase(param) = "solid" then
				if s.mytw <> invalid then s.mytw.SetBackgroundColor(255*256*256*256)				
			else if lcase(param) = "clear" then
					if s.mytw <> invalid then
						dlog("Clearing strings from Ticker")
						s.mytw.clear()
					endif
					
			else

				if s.mytw <> invalid then
					
					if ucase(right(param, 3)) = "TXT" then
						path$=""
						
						if s.bsp.syncpoolfiles <> invalid then 
							path$=GetPoolFilePath(s.bsp.syncPoolFiles, param)
						else if s.bsp.assetpoolfiles <> invalid then
							path$=GetPoolFilePath(s.bsp.assetpoolfiles, param)
						endif
						
						print "Debug, line 301, path =: ";path$
						if path$="" then
							s.newscroll()
							s.mytw.SetStringSource(param)
							S.mytw.show()
						else
							s.newscroll()
							s.mytw.SetStringSource(path$)
							S.mytw.show()
						endif
						
					else
						s.mytw.PushString(param)
					endif
				endif
			

			endif

		else if numFields = 3 then

			param = fields[1]	'command
			param2 = fields[2]	'String or file name
			print "3 fields"; param; param2
			
			if s.mytw <> invalid then
				if lcase(param) = "file" then
					if ucase(right(param2, 3)) = "TXT" then
						path$=""
						
						if s.bsp.syncpoolfiles <> invalid then 
							path$=GetPoolFilePath(s.bsp.syncPoolFiles, param)
						else if s.bsp.assetpoolfiles <> invalid then
							path$=GetPoolFilePath(s.bsp.assetpoolfiles, param)
						endif
						
						print "Debug, line 332, path =: ";path$
						if path$="" then
							s.newscroll()
							s.mytw.SetStringSource(param)
							S.mytw.show()
						else
							s.newscroll()
							s.mytw.SetStringSource(path$)
							S.mytw.show()
						endif

					endif
				
				else if lcase(param) = "add" then
					s.mytw.PushString(param2)
				
				else if lcase(param) = "replace" then
					nstring = s.mytw.GetStringCount()
					s.mytw.PushString(param2)	
					if nstring >= 1 then s.mytw.Popstrings(1)
				endif	
				
				
			endif
		
		else if numFields = 6 then
			param = fields[1]	'command
			param2 = int(val(fields[2]))	'String or file name
			param3 = int(val(fields[3]))
			param4 = int(val(fields[4]))
			param5 = int(val(fields[5]))
			print "6 fields"; param; param2; param3; param4; param5
			
			if lcase(param) = "scroll" then
				if param2 >= 0 and param2 <= 1900 then
						if param3 >= 0 and param3 <= 1060 then 
							if param4 >= 20 and param4 + param2 <= 1920 then 
								if param5 >= 20 and param5 + param3 <= 1080 then 
									s.mytickerbox = CreateObject("roRectangle",param2,param3,param4,param5)
									s.newscroll()
								endif
							endif
						endif
				endif
			endif

		endif
		
	endif

	return (retVal)
end Function

Function custom_getsettings(param$ as String) as Boolean
	
if lcase(param$) = "norot" then 
	m.setting$ = "identity"
	return true
else if lcase(param$) = "r90" then 
	m.setting$ = "rot90"
	return true
else if lcase(param$) = "r180" then 
	m.setting$ = "rot180"
	return true
else if lcase(param$) = "r270" then 
	m.setting$ = "rot270"
	return true
else if lcase(param$) = "mirror" then 
	m.setting$ = "mirror"
	return true
else if lcase(param$) = "m90" then 
	m.setting$ = "mirror_rot90"
	return true
else if lcase(param$) = "m180" then 
	m.setting$ = "mirror_rot180"
	return true
else if lcase(param$) = "m270" then 
	m.setting$ = "mirror_rot270"
	return true
endif
return false

end Function


'identity - no transformation (default behaviour if no transform specified)
'rot90 - 90 degree clockwise rotation
'rot180 - 180 degree rotation
'rot270 - 270 degree clockwise (90 degree anticlockwise) rotation
'mirror - horizontal mirror
'mirror_rot90 - mirror and 90 degree clockwise rotation
'mirror_rot180 - mirror and 180 degree rotation (a vertical reflection)
'mirror_rot270 - mirror and 270 degree rotation (a transpose).


Sub custom_findwidget()

	for each zone in m.bsp.sign.zonesHSM
		if zone.widget <> invalid then
			if type(zone.widget) = "roTextWidget" then
				m.mytwidget = zone.widget
				m.mytwidgetr = zone.rectangle
			endif
	
		endif
	next	
end Sub


sub dlog(message$ as string)
	slog = createobject("roSystemLog")
	slog.sendline(message$)
	'm.bsp.logging.WriteDiagnosticLogEntry("99plgn", (message$)
	'm.bsp.diagnostics.printdebug(message$)
	'if m.debug print (message$)

end sub
Sub ticker_newscroll()
		twParams = CreateObject("roAssociativeArray")
		twParams.LineCount = 1
		twParams.TextMode = 3
		twParams.Rotation = 0
		twParams.Alignment = 0
		m.mytw=CreateObject("roTextWidget",m.mytickerbox,1,2,twparams)		
End sub
