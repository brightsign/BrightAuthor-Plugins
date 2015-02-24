

Function chromaLuma_Initialize(msgPort As Object, userVariables As Object, bsp as Object) As Object

    print "chromaLuma_Initialize - entry"
    print "type of msgPort is ";type(msgPort)
    print "type of userVariables is ";type(userVariables)

    chromaLuma = newChromaLuma(msgPort, userVariables, bsp)

    return chromaLuma

End Function


Function newChromaLuma(msgPort As Object, userVariables As Object, bsp as Object) As Objectv

	print "chromaLuma"

	' Create the Object to return and set it up
	s = {}
	s.version = 1.0
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = chromaLuma_ProcessEvent
	s.ObjectName = "chromaLuma_Object"

	return s

End Function


Function chromaLuma_ProcessEvent(event As Object) as Boolean

	retval = false
    ' print "chromaLuma_ProcessEvent - entry"
    ' print "type of m is ";type(m)
    print "chromaLuma_ProcessEvent - type of event is ";type(event)

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "chromaLuma" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    retval = ParseChromaLuma(pluginMessage$, m)
                endif
            endif
        endif
	end if

	return retval

End Function


Function ParseChromaLuma(origMsg as String, chromaLuma as Object) as Boolean
	retval = false
		
	' convert the message to all lower case for easier String matching later
	msg = lcase(origMsg)
	print "Received Plugin message: " + msg
	' verify its a chromaLuma message, format: chromaLuma!<zonename>!<luma value>!<cr value>!<cb value>
	r = CreateObject("roRegex", "^chromaLuma", "i")
	match=r.IsMatch(msg)

	' Is this a chroma/luma request?
	if match then
		retval = true

		' split the String
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields = 5) then
            print "5 fields"
            zoneName = fields[1]
			
            lumaValue% = GetChromaLumaColor( fields[2] )
            crValue% = GetChromaLumaColor( fields[3] )
            cbValue% = GetChromaLumaColor( fields[4] )
            
			aa = {}
			aa.AddReplace("luma", lumaValue%)
			aa.AddReplace("cr", crValue%)
			aa.AddReplace("cb", cbValue%)
			
            ' find the zone in the list of zones
            for each zone in chromaLuma.bsp.sign.zonesHSM
                if (zone.name$ = zoneName) then
                    print "Found Zone"
                    print "Set chroma / luma in zone:";zoneName
                    if (zone.videoPlayer <> invalid) then
                        zone.videoPlayer.SetKeyingValue(aa)
                    else
                        print "No video player in zone:";zoneName
                    end if
                end if
            end for
		end if
	end if

	return (retVal)
	
End Function


Function GetChromaLumaColor( color$ As String ) As Integer

	ba = CreateObject("roByteArray")

	ba.FromHexString( mid( color$, 1, 2 ) )
	b0% = ba[0]
	
	ba.FromHexString( mid( color$, 3, 2 ) )
	b1% = ba[0]
	    
	ba.FromHexString( mid( color$, 5 ) )
	b2% = ba[0]
	    
    color_spec% = (b0%*256*256) + (b1%*256) + b2%
    return color_spec%

End Function



