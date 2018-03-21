REM Send TCP bytes BrightSign Plugin by wasam-np
REM (based on PJLink BrightSign Plugin by Tweaklab)
REM V0.1

Function SendTCPBytes_Initialize(msgPort As Object, userVariables As Object, o As Object)
	print "SendTCPBytes_Initialize - entry"
      	SendTCPBytesBuilder = newSendTCPBytesBuilder(msgPort, userVariables)
      	return SendTCPBytesBuilder
End Function

Function newSendTCPBytesBuilder(msgPort As Object, userVariables As Object)
      	SendTCPBytesBuilder = { }
      	SendTCPBytesBuilder.msgPort = msgPort
      	SendTCPBytesBuilder.userVariables = userVariables
      	SendTCPBytesBuilder.ProcessEvent = SendTCPBytes_ProcessEvent
      	return SendTCPBytesBuilder
End Function


Function SendTCPBytes_ProcessEvent(event As Object)
    print "SendTCPBytes_ProcessEvent:"
    print "Type of message is ";type(m)
    print "Type of event is ";type(event)

    if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
            if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
                if event["PluginName"] = "SendTCPBytes" then
                    pluginMessage$ = event["PluginMessage"]
                    print "Received pluginMessage ";pluginMessage$
                    tcpPacket = ParseJson(pluginMessage$)
                    tcpIp$ = tcpPacket.ip
                    tcpPort$ = tcpPacket.port
                    tcpPort# = val(tcpPort$)
                    tcpPort% = cint(tcpPort#)
                    tcpMessage$ = tcpPacket.message
                    socket = CreateObject("roTCPStream")
                    if socket = invalid then
                        print "could not create TCP stream object"
                        return false
                    endif
                    if socket.ConnectTo(tcpIp$, tcpPort%) then
                        bytes = CreateObject("roByteArray")
                        sleep(500)
                        bytes.FromHexString(tcpMessage$)
                        print "Sending TCP message: "; tcpMessage$
                        sock.SendBlock(bytes)
                        return true
                    else
                        print"Failed to connect to device via TCP"
                        socket = invalid
                    endif
                endif
            endif
        endif
    endif

    return false
End Function
