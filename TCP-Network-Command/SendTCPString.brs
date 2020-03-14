REM Send TCP string BrightSign Plugin by wasam-np
REM (losely based on PJLink BrightSign Plugin by Tweaklab)
REM V0.1

Function SendTCPString_Initialize(msgPort As Object, userVariables As Object, o As Object)
	print "SendTCPString_Initialize - entry"
      	SendTCPStringBuilder = newSendTCPStringBuilder(msgPort, userVariables)
      	return SendTCPStringBuilder
End Function

Function newSendTCPStringBuilder(msgPort As Object, userVariables As Object)
      	SendTCPStringBuilder = { }
      	SendTCPStringBuilder.msgPort = msgPort
      	SendTCPStringBuilder.userVariables = userVariables
      	SendTCPStringBuilder.ProcessEvent = SendTCPString_ProcessEvent
      	return SendTCPStringBuilder
End Function


Function SendTCPString_ProcessEvent(event As Object)
    print "SendTCPString_ProcessEvent:"
    print "Type of message is ";type(m)
    print "Type of event is ";type(event)

    if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
            if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
                if event["PluginName"] = "SendTCPString" then
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
                        bytes.FromAsciiString(tcpMessage$)
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
