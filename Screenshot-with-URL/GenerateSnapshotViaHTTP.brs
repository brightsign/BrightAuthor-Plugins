'20/02/18

'Generate snapshot when hitting a URL

'http://192.168.1.78:8081/mySnap

Function Custom_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

   'print "Custom_Initialize - entry"
   'print "type of msgPort is ";type(msgPort)
   'print "type of userVariables is ";type(userVariables)

    Custom = newCustom(msgPort, userVariables, bsp)
	
    return Custom

End Function



Function newCustom(msgPort As Object, userVariables As Object, bsp as Object)
	'print "initCustom"

	' Create the object to return and set it up
	
	s = {}
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = Custom_ProcessEvent
	s.sTime = CreateObject("roSystemTime") 
	s.HandleTimerEvent = HandleTimerEvent
	s.StartTimer = StartTimer
	s.readTimer = CreateObject("roTimer")
	s.readTimer.SetPort(s.msgPort)
	s.FirstCheck = true
	s.PluginSendMessage = PluginSendMessage
	s.Generate_SnapShot_to_Folder = Generate_SnapShot_to_Folder
	s.AddHttpHandlers = AddHttpHandlers
	s.GetEventinfo = GetEventinfo	
	s.AddStatusUrls = AddStatusUrls
	s.HandleHTTPEventPlugin = HandleHTTPEventPlugin
	s.nc = CreateObject("roNetworkConfiguration", 0)
	s.PlayerIP = ""
	s.currentConfig = ""
	s.currentConfig = s.nc.GetCurrentConfig() 

	if s.currentConfig <> invalid then	
		s.PlayerIP = s.currentConfig.ip4_address
		'print "eth0 IP Address "; s.currentConfig.ip4_address
			
	end if
	
	s.Storage = "SD:"
	s.Path = "/"
	s.vmPlugin = CreateObject("roVideoMode")
	
	s.AddHttpHandlers()
	
	's.StartTimer()
	
	return s

End Function



Function Generate_SnapShot_to_Folder()as boolean
	
	DoesSnapshotFolderExist = MatchFiles("/", "mySnap")

	if DoesSnapshotFolderExist.count() <= 0 then
	
		IsFoldercreationOK = CreateDirectory("mySnap")
		
		if IsFoldercreationOK then
			status = "true"
		else
			status = "false"
		end if 
		
		m.bsp.diagnostics.PrintDebug(" @@@ IsFoldercreationOK ? @@@ " + status)
		
	else if DoesSnapshotFolderExist.count() > 0 then
	
		screenShotParam = CreateObject("roAssociativeArray")
		'screenShotParam["filename"] = "SD:screen.jpg"
		screenShotParam["filename"] = m.Storage + m.Path + "mySnap/LastSnapshot.jpg"
		screenShotParam["width"] = m.vmPlugin.GetResX()
		screenShotParam["height"] = m.vmPlugin.GetResY()
		screenShotParam["filetype"] = "JPEG"
		screenShotParam["quality"] = 25
		screenShotParam["async"] = 0
		
		screenShotTaken = m.vmPlugin.Screenshot(screenShotParam)
		
		'Print " @@@ Screenshot Taken @@@  " screenShotTaken	
		
		if screenShotTaken then
			status = "true"
		else
			status = "false"
		end if 

		m.bsp.diagnostics.PrintDebug(" @@@ Screenshot Taken @@@ " + status)
	
	
	end if 
	


End Function
	
	
	
	
Function Custom_ProcessEvent(event As Object) as boolean

	retval = false
   print "Custom_ProcessEvent - entry"
   print "type of m is ";type(m)
   print "type of event is ";type(event)
   
   
   	if type(event) = "roHttpEvent" then
		retval = HandleHTTPEventPlugin(event, m)
	end if 

	if type(event) = "roTimerEvent" then
		retval = HandleTimerEvent(event, m)
	
	else if type(event) = "roAssociativeArray" then
		
		if type(event["EventType"]) = "roString"
			if event["EventType"] = "EVENT_PLUGIN_MESSAGE" then
				if event["PluginName"] = "Custom" then
					pluginMessage$ = event["PluginMessage"]
							
					'retval = HandlePluginMessageEvent(pluginMessage$)
					
				end if
			
			else if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
			
				if event["PluginName"] = "Custom" then
					pluginMessage$ = event["PluginMessage"]
					'retval = m.HandlePluginMessageEvent(pluginMessage$)
				end if
				
			end if
		end if
	
	end if
	
	return retval

End Function
	

Function HandleHTTPEventPlugin(origMsg as Object, Custom as Object) as boolean

	userData = origMsg.GetUserData()
	
	if type(userdata) = "roAssociativeArray" and type(userdata.HandleEvent) = "roFunction" then
		userData.HandleEvent(userData, origMsg)

	endif
	
End Function


Sub AddHttpHandlers()

	'the main autorun local webserver already has that variable name!!!
	'm.localServer = CreateObject("roHttpServer", { port: 8081 })
	'm.localServer.SetPort(m.msgPort)
	m.pluginLocalWebServer = CreateObject("roHttpServer", { port: 8081 })
	m.pluginLocalWebServer.SetPort(m.msgPort)
	m.AddStatusUrls()

End Sub


Sub AddStatusUrls()

	url$ = "/mySnap"

	m.GetEventinfoAA = { HandleEvent: m.GetEventinfo, mVar: m}
	m.eventSet = m.pluginLocalWebServer.AddGetFromEvent({ url_path: url$, user_data: m.GetEventinfoAA })
	
	
End Sub


Function GetEventinfo(userData as Object, e as Object) As Boolean

	FindLatestSnapshot = m.mvar.Generate_SnapShot_to_Folder()

	isTheHeaderAddedOK = e.AddResponseHeader("Content-type", "image/jpeg")
	e.SetResponseBodyFile("mySnap/LastSnapshot.jpg")
    e.SendResponse(200)

End Function




Function StartTimer()
	
	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(5)
	m.readTimer.SetDateTime(newTimeout)
	m.readTimer.Start()

End Function


Function HandleTimerEvent(origMsg as Object, Custom as Object) as boolean

	retval = false

	timerIdentity = origMsg.GetSourceIdentity()

	if Custom.readTimer.GetIdentity() = timerIdentity then
		timerIdentity = origMsg.GetSourceIdentity()
	end if

		
End Function


Function PluginSendMessage(Pmessage$ As String)

	pluginMessageCmd = CreateObject("roAssociativeArray")
	pluginMessageCmd["EventType"] = "EVENT_PLUGIN_MESSAGE"
	pluginMessageCmd["PluginName"] = "Custom"
	pluginMessageCmd["PluginMessage"] = Pmessage$
	m.msgPort.PostMessage(pluginMessageCmd)

End Function
