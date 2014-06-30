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
	s.version = .5
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = custom_ProcessEvent
	s.settings$=""
	s.getsettings = custom_getsettings
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
                    retval = ParsecustomPluginMsg(pluginMessage$, m)
                endif
            endif
        endif
	


	else if type(event) = "roDatagramEvent" then
			msg$ = event
			if (left(msg$,4) = "seek") then
				retval = ParsecustomPluginMsg(msg$, m)
			end if

			if (left(msg$,6) = "rotate") then
				retval = ParsecustomPluginMsg(msg$, m)
			end if
			
	
	end if

	return retval

End Function

Function ParsecustomPluginMsg(origMsg as string, s as object) as boolean
	print "Parsing plugin message command"
	retval = false
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: " + msg
	
	' verify its a rotate message'
	r = CreateObject("roRegex", "^rotate", "i")
	rotate_match=r.IsMatch(msg)

	'verify if it's a seek message
	q = CreateObject("roRegex", "^seek", "i")
	seek_match=q.IsMatch(msg)
	
	
	' Is this a rotate request
	if rotate_match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		
		if numFields = 3 then
			'expects rotate!zonename!setting

			print "3 Fields"
			zoneName$ = fields[1]
			param2 = fields[2]
			
			for each zone in s.bsp.sign.zonesHSM
				if (zone.name$ = zoneName$) then
					print "Found Rotate Zone: "; zonename$
					if s.getsettings(param2) then
						zone.videoPlayer.SetTransform(s.setting$)
					else
						zone.videoplayer.SetTransform()
					endif

				endif
			next
		else if numFields = 2 then
			param = fields[1]
			
			for each zone in s.bsp.sign.zonesHSM
				if zone.videoplayer <> invalid then 
					if s.getsettings(param) then 
						zone.videoplayer.SetTransform(s.setting$)
						exit for
					endif
				endif
			next
			
			'if s.getsettings(param) then s.bsp.sign.zoneshsm[0].videoplayer.SetTransform(s.setting$)
			
		endif
	
	
	else if seek_match then	'seek request
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		
		
		if numFields = 3 then
			'expects seek!zonename!timeinmilliseconds

			print "3 Fields"
			zoneName$ = fields[1]
			param2 = int(val(fields[2]))
			for each zone in s.bsp.sign.zonesHSM
				if (zone.name$ = zoneName$) then
					print "Found Seek Zone: "; zonename$
						zone.videoPlayer.Seek(param2)
				endif
			next
			
		else if numFields = 2 then
			param2 = int(val(fields[1]))
			
			for each zone in s.bsp.sign.zonesHSM
				if zone.videoplayer <> invalid then 
					zone.videoplayer.Seek(param2)
					exit for
				endif
			next
			
			's.bsp.sign.zoneshsm[0].videoplayer.Seek(param2)
		endif
		
	endif

	return (retVal)
end Function

Function custom_getsettings(param$ as String) as Boolean
	
if param$ = "norot" then 
	m.setting$ = "identity"
	return true
else if param$ = "r90" then 
	m.setting$ = "rot90"
	return true
else if param$ = "r180" then 
	m.setting$ = "rot180"
	return true
else if param$ = "r270" then 
	m.setting$ = "rot270"
	return true
else if param$ = "mirror" then 
	m.setting$ = "mirror"
	return true
else if param$ = "m90" then 
	m.setting$ = "mirror_rot90"
	return true
else if param$ = "m180" then 
	m.setting$ = "mirror_rot180"
	return true
else if param$ = "m270" then 
	m.setting$ = "mirror_rot270"
	return true
endif
return false

end Function


'identity - no transformation (default behaviour if no transform specified)
'rot90 - 90 degree clockwise rotation
'rot180 - 180 degree rotation
'rot270 - 270 degree clockwise (90 degree anticlockwise) rotation
'mirror - horizontal mirror
'mirror_rot90 - mirror and 90 degree clockwise rotation
'mirror_rot180 - mirror and 180 degree rotation (a vertical reflection)
'mirror_rot270 - mirror and 270 degree rotation (a transpose).
