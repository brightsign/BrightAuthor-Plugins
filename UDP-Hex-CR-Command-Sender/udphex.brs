Function udphex_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "udphexe_Initialize - entry"

    udphex = newudphex(msgPort, userVariables, bsp)

    return udphex

End Function


Function newudphex(msgPort As Object, userVariables As Object, bsp as Object)
	print "newudphex"

	s = {}
	s.version = 0.1
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = udphex_ProcessEvent
	s.objectName = "udphex_object"
	s.debug  = false
	return s
End Function


Function udphex_ProcessEvent(event As Object) as boolean
	print "processing event udphex plugin"
	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "udphex" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    retval = ParseudphexPluginMsg(pluginMessage$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$,3) = "udp") then
		    retval = ParseudphexPluginMsg(msg$, m)
		end if

	else if type(event) = "roTimerEvent" then

	end if

	return retval

End Function


Function ParseudphexPluginMsg(Msg as string, s as object) as boolean
	Print "Parseudphex function"
	retval  = false
	command = ""
	param =""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(Msg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^udp", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			print "Incorrect number of fields for udphex command:";msg
			return retval
		else if (numFields = 2) then
			command=fields[1]
			print "two fields found "; command 
			
			if type(s.bsp.udpsender) <> "roDatagramSender" then
					print "creating udp sender"
					s.bsp.udpsender = createobject("roDatagramSender")
					s.bsp.udpSender.SetDestination(s.bsp.udpAddress$, s.bsp.udpSendPort)	
			endif
			
			'command_with_cr$ = command + chr(13)
			mybytes=createobject("roByteArray")
			mybytes.FromHexString(command)
			s.bsp.udpSender.Send(mybytes)
			
		end if
		
	end if

	if command = "debug" then
	    s.debug=true
	end if

	return retval
end Function

