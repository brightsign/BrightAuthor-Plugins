Function udpcr_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "udpcre_Initialize - entry"

    udpcr = newudpcr(msgPort, userVariables, bsp)

    return udpcr

End Function


Function newudpcr(msgPort As Object, userVariables As Object, bsp as Object)
	print "newudpcr"

	s = {}
	s.version = 0.1
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = udpcr_ProcessEvent
	s.objectName = "udpcr_object"
	s.debug  = false
	return s
End Function


Function udpcr_ProcessEvent(event As Object) as boolean
	print "processing event udpcr plugin"
	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "udpcr" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    retval = ParseudpcrPluginMsg(pluginMessage$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$,3) = "udp") then
		    retval = ParseudpcrPluginMsg(msg$, m)
		end if

	else if type(event) = "roTimerEvent" then

	end if

	return retval

End Function


Function ParseudpcrPluginMsg(Msg as string, s as object) as boolean
	Print "Parseudpcr function"
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
			print "Incorrect number of fields for udpcre command:";msg
			return retval
		else if (numFields = 2) then
			command=fields[1]
			print "two fields found "; command 
			
			if type(s.bsp.udpsender) <> "roDatagramSender" then
					print "creating udp sender"
					s.bsp.udpsender = createobject("roDatagramSender")
					s.bsp.udpSender.SetDestination(s.bsp.udpAddress$, s.bsp.udpSendPort)	
			endif
			
			'cr 13
			'lf 10
			
			command_with_cr$ = command + chr(13)
			mybytes=createobject("roByteArray")
			mybytes.FromAsciiString(command_with_cr$)
			s.bsp.udpSender.Send(mybytes)
			
		end if
		
	end if

	if command = "debug" then
	    s.debug=true
	end if

	return retval
end Function

