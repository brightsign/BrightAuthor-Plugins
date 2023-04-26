' BrightSign Video Mode Plugin
' This plugin allows you to set video resolution, frame rate, colour space and depth
' The format of the plugin message is e.g. "brightsign!videomode!1920x1080x60i!444!10bit"
Function videomode_Initialize(msgPort As Object, userVariables As Object, bsp As Object)

    print "videomode_Initialize - entry"

    videomode = videomode_New(msgPort, userVariables, bsp)

    return videomode

End Function


Function videomode_New(msgPort As Object, userVariables As Object, bsp As Object)

	print "videomode_new - entry"

	' Create the object to return and set it up
	s = {}
	s.version = 1.0
	s.msgPort = msgPort
	s.bsp = bsp
	s.ProcessEvent = videomode_ProcessEvent
	s.objectName = "videomode_object"

	return s

End Function


Function videomode_ProcessEvent(event As Object) As boolean

	retval = false

	If type(event) = "roAssociativeArray" Then
		If type(event["EventType"]) = "roString" Then
			If (event["EventType"] = "SEND_PLUGIN_MESSAGE") Then
				If event["PluginName"] = "videomode" Then
					print "videomode_ProcessEvent - Plugin name is videomode"
					msg$ = event["PluginMessage"]
					print "videomode_ProcessEvent - SEND_PLUGIN_MESSAGE=";msg$
                    			retval = ParsePluginMsg(msg$, m)
				End If
			End If
		End If
	End If

	return retval

End Function

Function ParsePluginMsg(origMsg$ as String, m as Object) as boolean

	retval = false
		
	' Convert the message to all lower case for easier string matching later
	msg = lcase(origMsg$)
	print "Received Plugin message: "+msg

	' See if it is a Brightsign message
	' Format is "brightsign!videomode!1920x1080x60i!444!10bit"

	r1 = CreateObject("roRegex", "^brightsign", "i")
	match=r1.IsMatch(msg)
	If Not(match) Then
		return retval
	End If

	' We know it is a message for us, mark is as handled
	retval = true

	' Split on !
	r2 = CreateObject("roRegex", "!", "i")
	fields=r2.split(msg)

	numFields = fields.count()
	If (numFields < 3) or (numFields > 5) Then
		' Check the number of fields is correct
		print "************ Incorrect number of fields for BrightSign command:";msg
		return retval
	Else
		' Check the command (currently we only support one, "videomode"
		command =fields[1]
		If (command <> "videomode") Then
			print "************ Unknown type of BrightSign command:";command
			return retval
		End If
	End If
	
	options = ""
	If (numFields = 3) Then
		' Resolution/frame rate only
		options = fields[2]
	Else If (numFields = 4) Then
		' Resolution and colour space
		options = fields[2] + ":" + fields[3]
		field3 =""
	Else If (numFields = 5) Then
		' Resolution, colour space and depth
		options = fields[2] + ":" + fields[3] + ":" + fields[4]
	End If

	If Len(options) > 0 Then
		' We are ready to set the video mode
		vm=CreateObject("roVideoMode")
		print "Switching resolution; command is:";options
		result = vm.SetMode(options)
		If Not(result) Then
			print "************ Could not set video mode: invalid video mode:";options
		End If
	End If

	return retval

End Function
