Function setvideomode_SetVideoMode(videoModeInputs, bsp) As String

  print "setvideomode_SetVideoMode"
  print "type of videoModeInputs is ";type(videoModeInputs)
  print "type of bsp is ";type(bsp)

  print videoModeInputs

  return "1280x720x60p"

 End Function

Function newSetvideomodeBuilder(msgPort As Object, userVariables As Object, o As Object)

    SetvideomodeBuilder = { }
    SetvideomodeBuilder.msgPort = msgPort
    SetvideomodeBuilder.userVariables = userVariables
	SetvideomodeBuilder.o = o

    SetvideomodeBuilder.ProcessEvent = setvideomode_ProcessEvent

    return SetvideomodeBuilder

End Function


Function setvideomode_ProcessEvent(event As Object) As Boolean

    print "setvideomode_ProcessEvent - entry"
    print "type of m is ";type(m)
    print "type of event is ";type(event)

	if type(event) = "roAssociativeArray" then
		if type(event["EventType"]) = "roString"
			if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
				if event["PluginName"] = "Setvideomode" then
					pluginMessage$ = event["PluginMessage"]
					print "received pluginMessage ";pluginMessage$

					if pluginMessage$ = "cook" then
						' send Plugin message
						pluginMessageCmd = CreateObject("roAssociativeArray")
						pluginMessageCmd["EventType"] = "EVENT_PLUGIN_MESSAGE"
						pluginMessageCmd["PluginName"] = "Setvideomode"
						pluginMessageCmd["PluginMessage"] = m.type
						m.msgPort.PostMessage(pluginMessageCmd)
					else
						m.type = pluginMessage$
					endif

					return true
				endif
			endif
		endif
	endif

	return false

End Function
