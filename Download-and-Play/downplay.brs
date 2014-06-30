Function downplay_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "downplay_Initialize - entry"
    downplay = newdownplay(msgPort, userVariables, bsp)
    return downplay

End Function


Function newdownplay(msgPort As Object, userVariables As Object, bsp as Object)
	print "newdownplay"

	s = {}
	s.version = 0.91
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = downplay_ProcessEvent
	s.dlog = downplay_dlog
	s.getimage = downplay_getimage
	s.initimage = downplay_initimage
	s.playimage = downplay_playimage
	s.currentimage$ = "test.jpg"
	s.imagepath$ = "http://dl.dropboxusercontent.com/u/3480052/video/2.jpg"
	s.objectName = "downplay_object"
	s.debug  = true

	s.udpReceiverPort = 5000
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)


	return s
	
End Function


Function downplay_ProcessEvent(event As Object) as boolean
	m.bsp.diagnostics.printdebug("Processing downplay plugin events")
	retval = false

	if type(event) = "roAssociativeArray" then

        	if type(event["EventType"]) = "roString" then
             		if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                		if event["PluginName"] = "downplay" then
                    		pluginMessage$ = event["PluginMessage"]
							print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
							'messageToParse$ = event["PluginName"]+"!"+pluginMessage$
							m.dlog("Plugin Message: "+pluginMessage$)
							retval = ParsedownplayPluginMsg(pluginMessage$, m)
					
                		endif
            		endif
        	endif
		
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		m.dlog("UDP plugin event: "+msg$)
		if (left(msg$,8) = "downplay") then
		    retval = ParsedownplayPluginMsg(msg$, m)
		end if

	else if (type(event) = "roUrlEvent") then
		m.bsp.diagnostics.printdebug("downplay_plugin Url Event")
		
		count=0

		if event.GetSourceIdentity() = m.dimage.GetIdentity()
			if event.GetResponseCode() = 200 or event.GetResponseCode() = 0 then
				ok = m.dlog("Successfully downloaded file")
				m.playimage()
			else
				m.dlog("downplay not finished")
				m.dlog(str(event.GetResponseCode()))

			endif

		endif
		
	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then
		'm.bsp.diagnostics.printdebug("downplay_plugin Timer Event")
		'if event.GetSourceIdentity() = m.downplaytimer.GetIdentity()
		
	end if

	return retval

End Function



Function ParsedownplayPluginMsg(origMsg as string, s as object) as boolean
	retval  = false
	command = " "
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^downplay", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			s.dlog("Incorrect number of fields for downplay command:"+msg)
			return retval
		else if (numFields = 2) then
			command=fields[1]
		end if
	end if

	s.dlog("command found: " +command)

	if command = "debug" then
		s.dlog("Debug Enabled")
	    s.debug=true
	else if command = "reboot" then
		s.dlog("Rebooting")
	    	rebootsystem()
	else if command = "stop"
		if type(s.iplayer) = "roImagePlayer" then s.iplayer.stopdisplay()
		
	else if command <> " "
		s.imagepath$ = command
		s.currentimage$ = getname(command)
		s.getimage(s.currentimage$)
	endif
	
	return retval
end Function


Sub downplay_initimage()
	m.dlog("debug - Initimage - Setting url, msgport")
	
	dimage = createobject("roUrlTransfer")
	dimage.seturl(m.imagepath$)
	dimage.setport(m.msgport)
	
	m.dimage = dimage
	
End Sub

Sub downplay_getimage(file$ as string)
	m.dlog("downplay Plugin - Get Image")
	m.initimage()	'setting url
	
	if type(m.dimage) = "roUrlTransfer" then
			ok = m.dimage.AsyncGetToFile(file$)
			if ok = 0 then m.dlog("Error initiating downplay of " + file$)
	endif

	m.dlog("Completed - GetImage")
End Sub

Sub downplay_playimage()
	if type(m.iplayer) <> "roImagePlayer" then m.iplayer = createobject("roImagePlayer")
	m.iplayer.setdefaultmode(3) 'scale to fill
	m.iplayer.Displayfile(m.currentimage$)

end Sub


Sub downplay_dlog (error$ as String)
	m.bsp.logging.WriteDiagnosticLogEntry("99plgn", error$)
	'm.bsp.diagnostics.printdebug(error$)
	print error$
	slog = createobject("roSystemLog")
	slog.sendline(error$)
	
End Sub


Function getname (url$ as String) as String
	while true
		cpos = instr(1, url$, "/")
		if cpos > 0 then
			url$ = mid(url$, cpos+1)
		else
			exit while
		endif
	end while
	print ("Name retrieved: "+url$)
	
	return url$

End Function
