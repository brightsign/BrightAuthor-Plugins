Function countdown_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "countdown_Initialize - entry"

    countdown = newcountdown(msgPort, userVariables, bsp)

    return countdown

End Function


Function newcountdown(msgPort As Object, userVariables As Object, bsp as Object)
	print "newcountdown"

	s = {}
	s.version = 0.4
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = countdown_ProcessEvent
	s.objectName = "countdown_object"
	s.debug  = false
	's.udpAddress$ = s.bsp.udpAddress$ 'sets destination address to brightauthor setting. Currently disabled.
	's.udpAddress$="192.168.50.255"
	
	s.udpReceiverPort = 555	'listens for udp commands direct to plugin on this port. This can be changed also.
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(s.msgPort)

	
	return s
End Function


Function countdown_ProcessEvent(event As Object) as boolean
	print "countdown plugin event: "; type(event)

	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "countdown" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    retval = ParsecountdownPluginMsg(pluginMessage$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$,9) = "countdown") then
		    retval = ParsecountdownPluginMsg(msg$, m)
		end if

	else if type(event) = "roTimerEvent" then

	end if

	return retval

End Function


Function ParsecountdownPluginMsg(Msg as string, s as object) as boolean

	retval  = false
	command = ""
	param =""
	myvalue$ = ""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(Msg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^countdown", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			print "Incorrect number of fields for countdown command:";msg
			return retval
		else if (numFields = 2) then	'assumes command countdown!variablename
			command=fields[1]
		
			if s.userVariables.DoesExist(command) then
				myvariable = s.userVariables.Lookup(command)
				if myvariable <> invalid then 
					myvalue$ = myvariable.GetCurrentValue()
					print "Found Variable: "; command
					print "Variable Value: "; myvalue$

					tempval = val(myvalue$)
					If tempval > 0 then tempval = tempval - 1
					myvalue$ = str(tempval)
					myvalue$ = mid(myvalue$,2)
					myvariable.SetCurrentValue(myvalue$,true)
					
					'if type(s.bsp.udpsender) <> "roDatagramSender" then 
					'		s.bsp.udpsender = createobject("roDatagramSender")
					'		s.bsp.udpSender.SetDestination(s.udpAddress$, s.udpSendPort)	
					'endif
					's.bsp.udpsender.send(myvalue$)
					'myvariable.SetCurrentValue(myvalue$,true)	'disabled, sets value
				endif
			endif
	

			
		end if
	end if

	if command = "debug" then
	    s.debug=true
	end if

	return retval
end Function



