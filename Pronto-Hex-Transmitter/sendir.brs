Function sendir_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "sendir_Initialize - entry"

    sendir = newSendIR(msgPort, userVariables, bsp)

    return sendir

End Function


Function newSendIR(msgPort As Object, userVariables As Object, bsp as Object)
	print "newSendIR"

	s = {}
	s.version = 0.3
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = sendir_ProcessEvent
	s.objectName = "sendir_object"

	s.tvoff = "0000 0071 0000 0032 0080 003F 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0030 0010 0030 0010 0030 0010 0030 0010 0030 0010 0010 0010 0010 0010 0030 0010 0030 0010 0030 0010 0030 0010 0030 0010 0030 0010 0010 0010 0030 0010 0000"
	s.tvon  = "0000 0071 0000 0032 0080 003F 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0030 0010 0030 0010 0030 0010 0030 0010 0010 0010 0010 0010 0010 0010 0030 0010 0030 0010 0030 0010 0030 0010 0030 0010 0010 0010 0030 0010 0000"
	s.prjoff = "0000 0070 0000 003a 0080 0041 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 0030 000f 0030 000f 0030 000f 0030 000f 0030 000f 0030 000f 000f 000f 000f 000f 0030 000f 0030 000f 0030 000f 000f 000f 0030 000f 0030 000f 0030 000f 0030 000f 0000"
	s.prjon  = "0000 0070 0000 003a 0081 0041 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 0030 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 000f 0030 000f 0030 000f 0030 000f 0030 000f 0030 000f 000f 000f 000f 000f 000f 000f 0030 000f 0030 000f 000f 000f 0030 000f 0030 000f 0030 000f 0030 000f 0000"

	s.debug  = false

	s.ir = CreateObject("roIRRemote")
	if type(s.ir) = "roIRRemote" then	
	    print "IR object created successfully"
	else
		print "IR object creation failed. Verify unit supports IR output"
		stop
	endif

	s.udpReceiverPort = 21000
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)

	return s
End Function


Function sendir_ProcessEvent(event As Object) as boolean

	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "sendir" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
					messageToParse$ = event["PluginName"]+"!"+pluginMessage$
                    retval = ParselfnrenamePluginMsg(messageToParse$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$,6) = "sendir") then
		    retval = ParseSendIRPluginMsg(msg$, m)
		end if

	else if (type(event) = "roUrlEvent") then

	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then

	end if

	return retval

End Function



Function ParseSendIRPluginMsg(origMsg as string, s as object) as boolean

	retval  = false
	command = ""
		
	' convert message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^sendir", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			print "Incorrect number of fields for Sendir command:";msg
			return retval
		else if (numFields = 2) then
			command=fields[1]
		end if
	end if

	if command = "debug" then
	    	s.debug=true
	else
		newTransmit(s, command)
	end if

	return retval
end Function



Sub newTransmit(s as object, code$ as String) 
	c$="none"
	if type(s.ir) = "roIRRemote" then
		if s.DoesExist(code$) then 
			if s.debug=true then
			    print s.lookup(code$)
			end if
		        s.ir.send("PHC",s.lookup(code$))
		else
			if s.debug print "No IR code found: "; code$
		endif
	end if	
End Sub


