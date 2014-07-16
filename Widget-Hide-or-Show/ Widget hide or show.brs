Function custom_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "custom_Initialize - entry"
    print "type of msgPort is ";type(msgPort)
    print "type of userVariables is ";type(userVariables)

    custom = newcustom(msgPort, userVariables, bsp)

    return custom

End Function


Function newcustom(msgPort As Object, userVariables As Object, bsp as Object)
	print "initcustom"

	' Create the object to return and set it up
	s = {}
	s.version = 1.0
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = custom_ProcessEvent
	s.findwidget = custom_findwidget
	s.zonemessage = custom_zonemessage
	s.objectName = "custom_object"

	s.udpReceiverPort = 555
	s.udpReceiver = CreateObject("roDatagramReceiver", s.udpReceiverPort)
	s.udpReceiver.SetPort(msgPort)
	
	return s

End Function


Function custom_ProcessEvent(event As Object) as boolean

	retval = false
    ' print "custom_ProcessEvent - entry"
    ' print "type of m is ";type(m)
    print "custom_ProcessEvent - type of event is ";type(event)

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "custom" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    retval = ParsePluginMsg(pluginMessage$, m)
                endif
            endif
        endif
		
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		parsepluginmsg(msg$, m)
		'	if type(m.mycwidget) <> "roClockWidget" then m.findwidget()
		'	if m.mycwidget <> invalid then m.mycwidget.hide()

		
	end if

	return retval

End Function

Function ParsePluginMsg(origMsg as string, s as object) as boolean
	retval = false
	param=""
	
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: " + msg
	' verify its a custom message'

	r = CreateObject("roRegex", "^clock", "i")
	clock_match=r.IsMatch(msg)

	q = CreateObject("roRegex", "^ticker", "i")
	ticker_match=q.IsMatch(msg)
	
	' Is this a custom request
	if clock_match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()

		if(numFields = 3) then
			print "Clock 3 Fields"
			param = fields[1]
			zonename = ucase(fields[2])
			for each zone in s.bsp.sign.zonesHSM
				if (ucase(zone.name$) = zonename) then
					if zone.widget <> invalid then
						if ucase(param) = "HIDE" then
							zone.widget.hide()
						else if ucase(param) = "SHOW" then
							zone.widget.show()
						endif
					endif
				endif
			next
				
		else if(numFields = 2) then
				print "Clock 2 Fields"
				param = fields[1]
				if type(s.mycwidget) <> "roClockWidget" then s.findwidget("roClockWidget")
				if s.mycwidget <> invalid then
					if ucase(param) = "HIDE" then
						s.mycwidget.hide()
					else if ucase(param) = "SHOW" then
						s.mycwidget.show()
					endif
				endif
				
		end if
	else if ticker_match then 
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()

		if(numFields = 3) then
				print "Ticker 3 Fields"
				param = fields[1]
				zonename = ucase(fields[2])
				for each zone in s.bsp.sign.zonesHSM
					if (ucase(zone.name$) = zonename) then
						if zone.widget <> invalid then
							if ucase(param) = "HIDE" then
								zone.widget.hide()
							else if ucase(param) = "SHOW" then
								zone.widget.show()
							endif
						endif
					endif
				next
				
				
		else if(numFields = 2) then
				print "Ticker 2 Fields"
				param = fields[1]
				if type(s.mycwidget) <> "roTextWidget" then s.findwidget("roTextWidget")
				if s.mycwidget <> invalid then
					if ucase(param) = "HIDE" then
						s.mycwidget.hide()
					else if ucase(param) = "SHOW" then
						s.mycwidget.show()
					endif
				endif
				
		end if
		
		
	
	end if

	return (retVal)
end Function


Sub custom_findwidget(widgetype$ as String)

	for each zone in m.bsp.sign.zonesHSM
		if zone.widget <> invalid then
			'if type(zone.widget) = "roClockWidget" then
			if type(zone.widget) = widgetype$ then
				m.mycwidget = zone.widget
			endif
		endif
	next	
end Sub

Sub custom_zonemessage(msg$ as String)
		' send ZoneMessage message
		zoneMessageCmd = CreateObject("roAssociativeArray")
		zoneMessageCmd["EventType"] = "SEND_ZONE_MESSAGE"
		zoneMessageCmd["EventParameter"] = msg$
		m.msgPort.PostMessage(zoneMessageCmd)
End Sub
