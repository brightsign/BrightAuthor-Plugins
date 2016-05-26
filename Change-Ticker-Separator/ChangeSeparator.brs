'plugin name customT

Function customT_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "customT_Initialize - entry"
    print "type of msgPort is ";type(msgPort)
    print "type of userVariables is ";type(userVariables)

    customT = newcustomT(msgPort, userVariables, bsp)

    return customT

End Function


Function newcustomT(msgPort As Object, userVariables As Object, bsp as Object)
	print "initcustomT"

	' Create the object to return and set it up
	s = {}
	s.version = 1.0
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = customT_ProcessEvent
	s.findwidget = customT_findwidget
	s.zonemessage = customT_zonemessage
	s.objectName = "customT_object"
	s.symbol = ":circle:" 	'":diamond:", ":circle:", ":square:".
	
	return s

End Function


Function customT_ProcessEvent(event As Object) as boolean

	retval = false
    ' print "customT_ProcessEvent - entry"
    ' print "type of m is ";type(m)
    print "customT_ProcessEvent - type of event is ";type(event)
	m.findwidget()	'changes separator
	
	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "customT" then
                    pluginMessage$ = event["PluginMessage"]
					'print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    'retval = ParsePluginMsg(pluginMessage$, m)
                endif
            endif
        endif
		
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		'parsepluginmsg(msg$, m)
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
	' verify its a customT message'

	r = CreateObject("roRegex", "^clock", "i")
	clock_match=r.IsMatch(msg)

	q = CreateObject("roRegex", "^ticker", "i")
	ticker_match=q.IsMatch(msg)
	
	' Is this a customT request
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


Sub customT_findwidget()
	for each zone in m.bsp.sign.zonesHSM
		if zone.widget <> invalid then
			if type(zone.widget) = "roTextWidget" then
			'if type(zone.widget) = widgetype$ then
				m.mycwidget = zone.widget
				zone.widget.SetSeparator(m.symbol)
			endif
		endif
	next	
end Sub

Sub customT_zonemessage(msg$ as String)
		' send ZoneMessage message
		zoneMessageCmd = CreateObject("roAssociativeArray")
		zoneMessageCmd["EventType"] = "SEND_ZONE_MESSAGE"
		zoneMessageCmd["EventParameter"] = msg$
		m.msgPort.PostMessage(zoneMessageCmd)
End Sub
