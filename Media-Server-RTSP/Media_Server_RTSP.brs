Function server_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
    print "server_Initialize - entry"
    server = newserver(msgPort, userVariables, bsp)	
    return server

End Function


Function newserver(msgPort As Object, userVariables As Object, bsp as Object)
	print "newserver"
	
	s = {}
	s.version = 0.21
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = server_ProcessEvent
	s.serverActive = server_Active
	s.objectName = "server_object"
	s.debug  = false
	s.udpReceiverPort = 555
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)
	

	s.srvr = createobject("roMediaServer")
	if s.srvr <> invalid then
		s.srvr.start("rtsp:port=8090&threads=4&maxbitrate=20000")
	endif

	return s
End Function



Function server_ProcessEvent(event As Object) as boolean
	print "server process event"
	print type(event)
	
	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "server" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
					messageToParse$ = event["PluginName"]+"!"+pluginMessage$
                    retval = ParseserverPluginMsg(messageToParse$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$,6) = "server") then
		    retval = ParseserverPluginMsg(msg$, m)
		end if
	else if type(event) = "roVideoEvent"
		print "media event "; event.GetInt()

	else if (type(event) = "roUrlEvent") then

	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then

	end if

	return retval

End Function

Function server_Active () as Boolean
	if type(m.srvr) = "roMediaServer" then return true
	return false
End Function


Function ParseserverPluginMsg(origMsg as string, s as object) as boolean

	retval  = false
	command = ""
	param = ""
	param2 = ""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^server", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 4) then
			print "Incorrect number of fields for server command:";msg
			return retval
		else if (numFields = 2) then
			command=fields[1]
		else if (numFields = 3) then
			print "three fields"
			command=fields[1]
			param = fields[2]
		else if (numFields = 4) then	'play source destination
			command = fields[1]
			param = fields[2]
			param2 = fields[3]
		end if
	end if
	
	if s.serverractive() then
		'print "server active"
		if command = "debug" then
				s.debug=true
		else if command = "play" then
			'nothing yet
		end if
		
		
	else
		print "no media stream available"
	endif

	return retval
end Function





