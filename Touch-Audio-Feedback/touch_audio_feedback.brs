Function touch_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
'no spaces in names

    print "touch_Initialize - entry"

    touch = newtouch(msgPort, userVariables, bsp)
	touch.setaudio()
	
    return touch

End Function


Function newtouch(msgPort As Object, userVariables As Object, bsp as Object)
	print "newtouch"

	s = {}
	s.version = 0.7
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = touch_ProcessEvent
	s.SetAudio = touch_setAudio
	s.objectName = "touch_object"
	s.debug  = true
	s.player = CreateObject("roAudioPlayer")
	s.file$ = "ping.mp3"

	return s
End Function

Function touch_ProcessEvent(event As Object) as boolean
	print "touch_processevent"
	
	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "touch" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
					messageToParse$ = event["PluginName"]+"!"+pluginMessage$
                    retval = ParsetouchPluginMsg(messageToParse$, m)
                endif
            endif
        endif
	else if type(event) = "roTouchEvent" then
			m.bsp.diagnostics.printdebug("Touch Plugin - event detected")
			'if instr(1, m.file$, "sha1-") < 1 then m.file$ = GetPoolFilePath(m.bsp.syncPoolFiles, m.file$)
			m.file$ = GetPoolFilePath(m.bsp.syncPoolFiles, "ping.mp3")
			m.bsp.diagnostics.printdebug("audio response: "+m.file$)
			m.player.playfile(m.file$)
						
	else if (type(event) = "roUrlEvent") then

	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then

	endif

	return retval

End Function


Function ParsetouchPluginMsg(origMsg as string, s as object) as boolean
	retval  = false
	command = ""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^touch", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			s.bsp.diagnostics.printdebug("Incorrect number of fields for touch command:"+msg)
			return retval
		else if (numFields = 2) then
			command=fields[1]
		end if
	end if

	s.bsp.diagnostics.printdebug("command found: " +command)

	if command = "debug" then
		s.bsp.diagnostics.printdebug("Debug Enabled")
	    s.debug=true
	else if command = "reboot" then
		s.bsp.diagnostics.printdebug("Rebooting")
	    rebootsystem()
	else
		s.changenow(command)
	endif
	
	return retval
end Function


Sub touch_SetAudio()
	compressed = CreateObject("roArray", 1, true)
	hdmiAudioOutput = CreateObject("roAudioOutput", "HDMI")
	compressed.push(hdmiaudiooutput)
	m.player.SetCompressedAudioOutputs(compressed)
End Sub


