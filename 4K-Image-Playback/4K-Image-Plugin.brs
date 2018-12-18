'BA 4.1.0.9 Plugin to display 4K images stored in /4KImages folder
'Plugin message to play from the folder "FolderPlay"
'Plugin message to play normal BA playlist items "BAPlay"


Function PlayImagesFromFolder_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

	print "PlayImagesFromFolder_Initialize - entry"
    
	PlayImagesFromFolder = newPlayImagesFromFolder(msgPort, userVariables, bsp)
	
	return PlayImagesFromFolder

End Function



Function newPlayImagesFromFolder(msgPort As Object, userVariables As Object, bsp as Object)
	print "Play From Folder Plugin Object Created"

	' Create the object to return and set it up
	s = {}
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = PlayImagesFromFolder_ProcessEvent
	s.sTime = CreateObject("roSystemTime")
	s.ImageTimer=CreateObject("roTimer")
	s.GoTimer=CreateObject("roTimer")
	s.ImageTimer.SetPort(s.msgport)
	s.GoTimer.SetPort(s.msgport)

	s.timeOnScreen = 6000
	s.CheckCardForMediaFiles = CheckCardForMediaFiles
	s.FileListMain = invalid
	s.SortFilesABC = SortFilesABC
	s.PlayfilesFromStorageMedia = PlayfilesFromStorageMedia
	s.IndexTracker = -1
	s.ResetIndexTracker = false
	s.StartImageTimer = StartImageTimer
	s.ImageTimerTimeout = Val(s.uservariables.ImageTimeOUTinSeconds.currentvalue$)
	s.StartTimer = StartTimer
	s.PluginSendMessage = PluginSendMessage
	s.HandlePluginMessageEvent = HandlePluginMessageEvent
	

	s.objectName = "PlayImagesFromFolder_object"
	
	's.StartTimer()
	
	return s
End Function



Function PlayImagesFromFolder_ProcessEvent(event As Object) as boolean

	retval = false
	print "PlayImagesFromFolder_ProcessEvent - entry"
	'print "type of m is ";type(m)
	'print "type of event is ";type(event)

	if type(event) = "roVideoEvent" then
			VideoPlayerEventReceived = event.GetInt()
			
			if VideoPlayerEventReceived = 8 then 	
				m.IndexTracker = m.IndexTracker + 1	
				'print "m.IndexTracker after VideoEnd Event " m.IndexTracker
				'print stri(VideoPlayerEventReceived) + " Video Event Received"
				'Should be removed just added for testing
				'retval = m.CheckCardForMediaFiles()
				'retval = false
			end if
		
		
	else if type(event) = "roTimerEvent" then
		
			timerIdentity = event.GetSourceIdentity()
			
			if m.ImageTimer.GetIdentity() = timerIdentity then
				m.IndexTracker = m.IndexTracker + 1
				retval = m.PlayfilesFromStorageMedia(m.FileListPN, m.FileTypePN, m.listPN, m.sizePN)		
			
			else if m.GoTimer.GetIdentity() = timerIdentity then
				
				m.PluginSendMessage("FolderPlay")
				retval = m.CheckCardForMediaFiles()
			
			end if	
		
	else if type(event) = "roAssociativeArray" then
		
		if type(event["EventType"]) = "roString"
			'if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
			if event["EventType"] = "EVENT_PLUGIN_MESSAGE" then
				if event["PluginName"] = "PlayImagesFromFolder" then
					pluginMessage$ = event["PluginMessage"]
							
					retval = m.HandlePluginMessageEvent(pluginMessage$)
					
				end if
			
			else if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
				if event["PluginName"] = "PlayImagesFromFolder" then
					pluginMessage$ = event["PluginMessage"]
				
					retval = m.HandlePluginMessageEvent(pluginMessage$)
					
				end if
				
			end if
		end if
	end if

	return retval

End Function



Function HandlePluginMessageEvent(pluginMessage$ as String) as boolean

	retval = false
	
	if pluginMessage$ = "FolderPlay" then
		
		print " ||||| FolderPlay pluginMessage$ event received ||||| "
		'REM Look for new root folder in variable
		if m.userVariables.DoesExist("ImageFolder") then
			m.ImageFolder$ = m.userVariables.ImageFolder.currentvalue$
			print "** User has set ImageFolder"
		else 
			m.ImageFolder$ = "SD:/4KImages"
			print "** Using default image folder path *"
		end if
		print "Image folder is " m.ImageFolder$
		
		
		'Make sense to ClearImagePlane here?
		m.bsp.sign.zoneshsm[0].ClearImagePlane()
		print " Checking for media files "
		retval = m.CheckCardForMediaFiles()
		
	else if pluginMessage$ = "BAPlay" then
	
		print " ||||| BAPlay pluginMessage$ event received ||||| "
		return retval
	
	end if
		
	return retval

End Function



Function CheckCardForMediaFiles() As Boolean
	
	m.FileListPN = CreateObject("roArray", 1, true)
	m.FileTypePN = CreateObject("roArray", 1, true)
	retval = false
	m.count = 0
	m.positionPN = 0
	m.sizePN = 0
	print ">> ImageFolder is " m.ImageFolder$ " <<"

	m.listPN = ListDir(m.ImageFolder$)
	
	'add files to list
	'------------------
	for each file in m.listPN 
		
		if ucase(right(file,3)) = "JPG" or ucase(right(file,3)) = "BMP" or ucase(right(file,3)) = "PNG" then 
			m.FileListPN[m.count] = ucase(file)
			m.FileTypePN[m.count] = "I"
			print "Found: file " stri(m.count) " named: " file
			m.count = m.count + 1
		end if
	next
	
	m.sizePN = m.count
	
	if m.FileListPN.count() = 0 then
		print "No Files Found"
		sleep(10000)
	else
		print stri(m.count) + " Files found on Media Storage "
		'print" m.list" m.list
	end if
	
	retval = m.SortFilesABC(m.FileListPN, m.FileTypePN, m.listPN)
	return retval

End Function



Function SortFilesABC(FileList as Object, FileType as Object, list as Object) As Boolean

	print "Sorting file listing"
	if m.sizePN > 0 then
		for i% = m.sizePN - 1 to 1 step -1
			for j% = 0 to i% - 1
				if m.FileListPN[j%] > m.FileListPN[j%+1] then
					tmp = m.FileListPN[j%]
					m.FileListPN[j%] = m.FileListPN[j%+1]
					m.FileListPN[j%+1] = tmp
			    
					ttmp$ = m.FileTypePN[j%]
					m.FileTypePN[j%]=m.FileTypePN[j%+1]
					m.FileTypePN[j%+1]=ttmp$
				end if
			next
		next
	end if
	
	retval = false
	print "About to play files from storage media"
	retval = m.PlayfilesFromStorageMedia(m.FileListPN, m.FileTypePN, m.listPN, m.sizePN)
	print " m.FileList" + Chr(13) + Chr(10) m.FileListPN
	
End Function



Function PlayfilesFromStorageMedia(FileList as Object, FileType as Object, list as Object, size as Integer) As Boolean

	ok = false

	if m.sizePN >= 0 then
		
		if m.IndexTracker = -1  then	
		
			m.IndexTracker = 0
			
		else if m.IndexTracker = m.sizePN
		
			m.PluginSendMessage("BAPlay")
			m.ImageTimer.Stop()
			m.bsp.sign.zoneshsm[0].videoplayer.StopClear()
			m.IndexTracker = -1
			
		end if
		
		
		if m.IndexTracker <= m.sizePN then			
					
			if m.FileTypePN[m.IndexTracker] = "I" then
				imgFileName=m.ImageFolder$ + "/"+ m.FileListPN[m.IndexTracker]
				print "Playing static image " imgFileName
				'ok = m.bsp.sign.zoneshsm[0].videoplayer.PlayStaticImage(m.ImageFolder$+m.FileListPN[m.IndexTracker])
				ok = m.bsp.sign.zoneshsm[0].videoplayer.PlayStaticImage(imgFileName)

				m.StartImageTimer()
			end if					
		end if
		
	end if
	
	return ok
	
End Function


Function StartImageTimer()

	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(m.ImageTimerTimeout)
	m.ImageTimer.SetDateTime(newTimeout)
	m.ImageTimer.Start()

End Function


Function StartTimer()
	
	StartTimeout = m.sTime.GetLocalDateTime()
	StartTimeout.AddSeconds(5)
	m.GoTimer.SetDateTime(StartTimeout)
	m.GoTimer.Start()

End Function


Function PluginSendMessage(Pmessage$ As String)

	pluginMessageCmd = CreateObject("roAssociativeArray")
	pluginMessageCmd["EventType"] = "EVENT_PLUGIN_MESSAGE"
	pluginMessageCmd["PluginName"] = "PlayImagesFromFolder"
	pluginMessageCmd["PluginMessage"] = Pmessage$
	m.msgPort.PostMessage(pluginMessageCmd)

End Function
