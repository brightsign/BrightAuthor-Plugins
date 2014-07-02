Function telnet_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
'no spaces in names

    print "telnet_Initialize - entry"

    telnet = newtelnet(msgPort, userVariables, bsp)
    return telnet

End Function


Function newtelnet(msgPort As Object, userVariables As Object, bsp as Object)
	print "newtelnet"

	s = {}
	s.version = 0.1
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = telnet_ProcessEvent
	s.objectName = "telnet_object"
	s.debug  = true
	
	s.udpReceiverPort = 555
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)
	return s
End Function

Function telnet_ProcessEvent(event As Object) as boolean
	print "telnet_processevent"
	
	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "telnet" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
					messageToParse$ = event["PluginName"]+"!"+pluginMessage$
                    retval = ParsetelnetPluginMsg(messageToParse$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$,6) = "telnet") then
		    retval = ParsetelnetPluginMsg(msg$, m)
		end if

	else if (type(event) = "roUrlEvent") then

	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then

	end if

	return retval

End Function


Sub telnetoff()
	registrySection = CreateObject("roRegistrySection", "networking")
	if type(registrySection)<>"roRegistrySection" then 
		print "Error: Unable to create roRegistrySection"
		
	else
		registrySection.Write("telnet", " ")
		registrySEction.flush()
		registrySection=invalid
		'rebootsystem()	'might want to reboot manually
	endif
End Sub

Sub telneton()
	registrySection = CreateObject("roRegistrySection", "networking")
	if type(registrySection)<>"roRegistrySection" then 
		print "Error: Unable to create roRegistrySection"
		
	else
		registrySection.Write("telnet", "23")
		registrySEction.flush()
		registrySection=invalid
		'rebootsystem()	'might want to reboot manually
	endif
End Sub

Function ParsetelnetPluginMsg(origMsg as string, s as object) as boolean
	retval  = false
	command = ""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^telnet", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			s.bsp.diagnostics.printdebug("Incorrect number of fields for telnet command:"+msg)
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
	else if command ="on" then 
		telneton()
	else if command = "off" then
		telnetoff()
	endif
	
	return retval
end Function





