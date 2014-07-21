'switch!save!current presentation name
'switch!restore

Function switch_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
'add timer function to check the variable name very 30 seconds


    print "switch_Initialize - entry"

    switch = newswitch(msgPort, userVariables, bsp)

    return switch

End Function


Function newswitch(msgPort As Object, userVariables As Object, bsp as Object)
	print "newswitch"

	s = {}
	s.version = 1.0
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = switch_ProcessEvent
	s.ChangeNow = switch_ChangeNow
	s.objectName = "switch_object"
	s.debug  = true
	
	s.udpReceiverPort = 555
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)
	return s
End Function

Function switch_ProcessEvent(event As Object) as boolean
	m.bsp.diagnostics.PrintDebug("switch_processevent")
	
	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "switch" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
					messageToParse$ = event["PluginName"]+"!"+pluginMessage$
                    retval = ParseswitchPluginMsg(messageToParse$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$,6) = "switch") then
		    retval = ParseswitchPluginMsg(msg$, m)
		endif

	else if (type(event) = "roUrlEvent") then

	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then

	endif

	return retval

End Function

Sub switch_changenow(presentationName$ as string)
	m.bsp.diagnostics.PrintDebug("changenow - switches presentation")
	
	' retrieve target presentation
	presentation = m.bsp.presentations.Lookup(presentationName$)

	if type(presentation) = "roAssociativeArray" then

		' check for existence of target presentation - if it's not present, don't try to switch to it
		m.bsp.diagnostics.PrintDebug("changenow - Found Presentation object")
		autoplayFileName$ = "autoplay-" + presentation.presentationName$ + ".xml"
		
		if m.bsp.syncpoolfiles <> invalid then 
			xmlFileName$ = GetPoolFilePath(m.bsp.syncPoolFiles,autoplayFileName$)
		else if m.bsp.assetPoolFiles <> invalid then 
			xmlFileName$ = GetPoolFilePath(m.bsp.assetPoolFiles,autoplayFileName$)
		else
			m.bsp.diagnostics.PrintDebug("Both Assetpool and Syncpool can't be found. Shouldn't happen")
		endif
		
		
		if xmlFileName$ = "" then
			m.bsp.diagnostics.PrintDebug("switchPresentation plugin: target presentation not found - " + presentationName$)
			'return false
		endif

		' send internal message to prepare for restart
		prepareForRestartEvent = CreateObject("roAssociativeArray")
		prepareForRestartEvent["EventType"] = "PREPARE_FOR_RESTART"
		m.bsp.msgPort.PostMessage(prepareForRestartEvent)

		' send switch presentation internal message
		switchPresentationEvent = CreateObject("roAssociativeArray")
		switchPresentationEvent["EventType"] = "SWITCH_PRESENTATION"
		switchPresentationEvent["Presentation"] = presentation.presentationName$
		m.bsp.msgPort.PostMessage(switchPresentationEvent)
	
		'return true

	endif

	'return false
				
End Sub


Function ParseswitchPluginMsg(origMsg as string, s as object) as boolean
	retval  = false
	command = ""
	param$ = ""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^switch", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 3) then
			s.bsp.diagnostics.printdebug("Incorrect number of fields for switch command:"+msg)
			return retval
		else if (numFields = 2) then
			command=fields[1]
		else if (numFields = 3) then
			command=fields[1]
			param$ = fields[2]
		endif
	end if

	s.bsp.diagnostics.printdebug("command found: " +command)

	if command = "debug" then
		s.bsp.diagnostics.printdebug("Debug Enabled")
	    s.debug=true
	else if command = "reboot" then
		s.bsp.diagnostics.printdebug("Rebooting")
	    rebootsystem()
		
	else if command = "restore" then
		oldpres = createobject("roReadFile", "switched.txt")
		if type(oldpres) = "roReadFile" then 

			While not oldpres.AtEof()
				presname$=oldpres.readline()
				if len(presname$) > 0 exit while
			end while
			if len(presname$) > 0 then s.changenow(presname$)
		else
			s.bsp.diagnostics.printdebug("Can't Find or Read switched.txt")
		endif
	
	else if command = "save" then
			deletefile("switched.txt")
			f = createobject("roCreateFile", "switched.txt")
			f.sendline(param$)
			f.flush()
	
	else
		s.changenow(command)
	endif
	
	return retval
end Function





