REM ViewSonic BrightSign Plugin by wasam-np
REM (based on PJLink BrightSign Plugin by Tweaklab)
REM V0.1

Function ViewSonicOff_Initialize(msgPort As Object, userVariables As Object, o As Object)
	print "ViewSonicOff_Initialize - entry"
      	ViewSonicOffBuilder = newViewSonicOffBuilder(msgPort, userVariables)
      	return ViewSonicOffBuilder
End Function

Function newViewSonicOffBuilder(msgPort As Object, userVariables As Object)
      	ViewSonicOffBuilder = { }
      	ViewSonicOffBuilder.msgPort = msgPort
      	ViewSonicOffBuilder.userVariables = userVariables
      	ViewSonicOffBuilder.ProcessEvent = ViewSonicOff_ProcessEvent
      	return ViewSonicOffBuilder
End Function


Function ViewSonicOff_ProcessEvent(event As Object)
      	print "ViewSonicOff_ProcessEvent:"
      	print "Type of message is ";type(m)
      	print "Type of event is ";type(event)

REM set standard ViewSonic port 4661
REM define the power off message in HEX to power OFF the projector

	projector_port=4661
	projector_message$="0614000400341101005E"

      	if type(event) = "roAssociativeArray" then
          	if type(event["EventType"]) = "roString"
              		if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
				if event["PluginName"] = "ViewSonicOff" then
                      			pluginMessage$ = event["PluginMessage"]
                      			print "Received pluginMessage ";pluginMessage$
					projector_ip$ = pluginMessage$
					print"Connecting to projector at "; projector_ip$ ":"; projector_port
					sock=CreateObject("roTCPStream")
					if sock=invalid then
						print"Failed to create roTCPClient object"
						stop
					endif
					if sock.ConnectTo(projector_ip$, projector_port) then
						print"Connected"
						bytes = CreateObject("roByteArray")
						sleep(500)
						bytes.FromHexString(projector_message$)
						print "Sending ViewSonic message: "; projector_message$
						sock.SendBlock(bytes)
						return true
					else
						print"Failed to connect to projector"
						sock=invalid
					endif
				endif
			endif
		endif
	endif

	return false
End Function
