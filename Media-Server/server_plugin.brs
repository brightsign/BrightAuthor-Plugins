'streamdisplayenabled - if enabled, display output served enabled
'HDMIoutenabled - if enabled, hdmin input served enabled
'Plugin creates Media Server that waits for clients to connect, and start stream
'XD players Support up to 4 19Mbps streams when files aren't being read from the sd card
'MPEG-2 transport stream
'No transcode support for XD players

'rtsp server, port 8090
'Streaming File from Client: rtsp://ServerIpAddress:8090/file:///folder/file.ts
'rtsp://ServerIpAddress:8090/file:///file.ts

'Stream HDMI input from client
'rtsp://serverIPAddress:8090/mem:/hdmi/stream.ts

'Stream display output from client
'rtsp://serverIPAddress:8090/mem:/display/stream.ts

'hdmimultienabled - serves hdmi input to multicast address on startup or project start

Function server_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
    print "server_Initialize - entry"
    server = newserver(msgPort, userVariables, bsp)	
    return server

End Function


Function newserver(msgPort As Object, userVariables As Object, bsp as Object)
	print "newserver"
	
	s = {}
	s.version = 1.3
	
	'only 1 streaming option below can be set to start automatically
	s.streamdisplayenabled = false	'stream display output automatically
	s.hdmioutenabled = true	'stream hdmi output automatically
	s.hdmimultienabled = false		'stream hdmi output automatically to multicast
	
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = server_ProcessEvent
	's.serverActive = server_Active
	s.objectName = "server_object"
	s.debug  = false
	s.udpReceiverPort = 555
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)
	s.rtsp = true
	s.http = false
	s.strmstarted = false		
	
	s.multicast$ = "" 'example rtp://239.192.0.0:5004/"
	s.tunerdefault$ = "tuner:///RfChannel=15&VirtualChannel=11.1, mem:/rf"
	s.gettuned = server_gettuned
	

	s.srvr = createobject("roMediaServer")
	if s.srvr <> invalid then
		if s.rtsp then 
			s.srvr.start("rtsp:port=8090&threads=5&maxbitrate=6000")
		else if s.http then 
			s.srvr.start("http:port=8090")
		endif
	endif

	s.servertimer = createobject("roTimer")
	newTimeout = s.bsp.systemTime.GetLocalDateTime()
	newTimeout.AddSeconds(3)
	s.servertimer.SetDateTime(newTimeout)
	s.servertimer.SetPort(s.msgPort)
	s.servertimer.Start()

	return s
End Function



Function server_ProcessEvent(event As Object) as boolean
	print "server process event"
	print type(event)
	
	retval = false
		'enable streaming of display xd2 and 4k and above
		
		if m.strmstarted = false then 
			If m.streamdisplayenabled then
				print "Start display output enabled"
				m.strmstarted = true
				
				pipleline$ ="display:mode=1&vformat=720p30&vbitrate=8000,encoder:,"
				address$ = "mem:/display"
				if m.multicast$ <> "" then address$ = m.multicast$

				if type(m.strmr) <> "roMediaStreamer" then m.strmr = CreateObject("roMediaStreamer")
					if m.strmr <> invalid then
						m.strmr.reset()
						m.strmr.SetPipeline(pipleline$+address$)
						m.strmr.start()
					else
						print "Failed to create Display streamer..."
				endif
			else if m.hdmioutenabled then
				print "start HDMI out enabled"
				m.strmstarted = true
				pipleline$="hdmi:,encoder:vformat=720p60&vbitrate=8000,"
				address$ = "mem:/hdmi"
				'address$ = m.multicast$	'to use multicast address instead
				
				if type(m.strmr) <> "roMediaStreamer" then m.strmr = CreateObject("roMediaStreamer")
					if m.strmr <> invalid then
						m.strmr.reset()
						m.strmr.SetPipeline(pipleline$+address$)
						m.strmr.start()
					else
						print "Failed to create HDMI streamer..."
					endif
				
			else if m.hdmimultienabled then 
				print "Start HDMI out to multicast enabled"
				m.strmstarted = true
					if type(m.strmr) <> "roMediaStreamer" then m.strmr = CreateObject("roMediaStreamer")
					if m.strmr <> invalid then
						pipelineaddress$ = "hdmi:,encoder:vformat=720p30&vbitrate=8000,"+m.multicast$
						m.strmr.reset()
						m.strmr.SetPipeline(pipelineaddress$)
						m.strmr.start()
					else
						print "Failed to create HDMI streamer..."
					endif			
			endif
			
		endif
		
	
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
	
	if s.srvr <> invalid then
		'print "server active"
		if command = "debug" then
			s.debug=true
		else if command = "http" then
			s.http = true
			s.srvr.stop()
			s.srvr.start("http:port=8090")
		else if command = "http10" then
			s.http = true
			s.srvr.stop()
			s.srvr.start("http:port=8090&threads=10")
			
		else if command = "rtsp" then
			s.rtsp = true
			s.srvr.stop()
			s.srvr.start("rtsp:port=8090")
			
		else if command = "stop" then
			if s.strmr <> invalid then s.strmr.reset()
			
		else if command = "hdmi" then
			pipleline$ ="hdmi:,encoder:vformat=720p60&vbitrate=8000,"
			destination$ = "mem:/hdmi"
			if param <> "" then destination$=param
			
			s.strmr = invalid		
			if type(s.strmr) <> "roMediaStreamer" then s.strmr = CreateObject("roMediaStreamer")
			if s.strmr <> invalid then
				s.strmr.reset()
				's.strmr.SetPipeline("hdmi:,encoder:,mem:/hdmi?size=5")	'5MB blocks for streaming
				s.strmr.SetPipeline(pipleline$+destination$)
				s.strmr.start()
			else
				print "Failed to create HDMI streamer..."
			endif
			
			
			
		else if command = "display" then
			pipleline$ ="display:mode=1&vformat=720p30&vbitrate=8000,encoder:,"
			destination$ = "mem:/display"
			if param <> "" then destination$=param		
		
			s.strmr = invalid
			if type(s.strmr) <> "roMediaStreamer" then s.strmr = CreateObject("roMediaStreamer")
			if s.strmr <> invalid then
				s.strmr.reset()
				s.strmr.SetPipeline(pipleline$+destination$)
				s.strmr.start()
			else
				print "Failed to create Display streamer..."
			endif
			
		else if command = "rf" then
			s.strmr = invalid
			if type(s.strmr) <> "roMediaStreamer" then s.strmr = CreateObject("roMediaStreamer")
			if s.strmr <> invalid then
				s.strmr.reset()
				s.gettuned()
				s.strmr.SetPipeline(s.tunerdefault$)
				s.strmr.start()
			else
				print "Failed to create RF streamer..."
			endif
			
		else if command = "play" then
			'nothing yet
		end if
		
		
	else
		print "no media server available"
	endif

	return retval
end Function


Sub server_gettuned()
'setting tunerdefault$
rf$=""
virtual$=""

	if m.userVariables.DoesExist("rf") and m.userVariables.DoesExist("virtual") then
		mrf=m.userVariables.Lookup("rf")
		mvirtual=m.userVariables.Lookup("virtual")
		
		if mrf <> invalid and mvirtual <> invalid then
			rf$=mrf.GetCurrentValue()
			virtual$=mvirtual.GetCurrentValue()
			channel$ ="tuner:///RfChannel="+rf$+"&VirtualChannel="+virtual$+", mem:/rf"
			print channel$
			m.tunerdefault$=channel$
		endif
	endif
	
end Sub

'server options
'Maxbitrate - sets the maximum instantaneous bitrate of the RTP transfer initiated by RTSP. Has no effect for HTTP. 
'The units are in Kbps; the parameter value 80000 (meaning 80Mbps) has been found to work well for streaming to Cheetahs. 
'The default behaviour (also achieved by passing the value zero) is not to limit the bitrate at all. Example: "rtsp:port=554&trace&maxbitrate=80000"

'Threads - Each thread handles one client; default value is 5. Example: "http:port=8080&threads=10"

'Streaming display output
'display:mode=2&vformat=720p30&vbitrate=2000	
'mode 2 scales well, but doesn't support output that has two videos playing
'mode 1 only scales horizontally, but supports 2 videos playing
