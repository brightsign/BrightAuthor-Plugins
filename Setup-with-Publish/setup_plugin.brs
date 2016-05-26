'Prior pool folder preserved if you don't include pool
' folder inside the autorun.zip file

'deletes uservariables.db file before reboot
'reconfigure unit setup immediately


Function setup_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
'v1.0
    mylog("setup_Initialize - entry")
    print "type of msgPort is ";type(msgPort)
    print "type of userVariables is ";type(userVariables)

    setup = newsetup(msgPort, userVariables, bsp)

    return setup

End Function


Function newsetup(msgPort As Object, userVariables As Object, bsp as Object)
	print "initsetup"

	' Create the object to return and set it up
	s = {}
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = setup_ProcessEvent
	s.Change = Change
	s.mylog = mylog
	s.objectName = "setup_object"

	return s
End Function

Function setup_ProcessEvent(event As Object) as boolean

	m.change()	'do resetup immediately
	retval = false
        m.mylog("setup_ProcessEvent - entry")
    	m.mylog("type of event is " + type(event))

	if type(event) = "roAssociativeArray" then

        	if type(event["EventType"]) = "roString" then
             		if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                		if event["PluginName"] = "setup" then
	                    		pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
					'messageToParse$ = event["PluginName"]+"!"+pluginMessage$
					m.mylog("Plugin Message: "+pluginMessage$)
					retval = ParsesetupPluginMsg(pluginMessage$, m)
                		endif
            		endif
        	endif

	else if type(event) = "roHtmlWidgetEvent" then
	'	retval = EnableWebInspect(event, m)
	end if

	return retval

End Function

Function ParsesetupPluginMsg(origMsg as string, s as object) as boolean
	retval  = false
	command = " "
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^setup", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			s.mylog("Incorrect number of fields for downplay command:"+msg)
			return retval
		else if (numFields = 2) then
			command=fields[1]
		end if
	end if

	s.mylog("command found: " +command)

	if command = "debug" then
		s.mylog("Debug Enabled")
	    s.debug=true
	else if command = "reboot" then
		s.mylog("Rebooting")
	    	rebootsystem()
	else if command = "unit"
		s.change()
	endif
	
	return retval
end Function



sub mylog(message$ as string)
	print message$
	slog = createobject("roSystemLog")
	slog.sendline(message$)
	m.bsp.logging.WriteDiagnosticLogEntry("99plgn", message$)
	m.bsp.diagnostics.printdebug(message$)
end sub


Sub Change()

	aok = false 'autorun
	cok = false 'setup
	sok = false 'sync
	dok = false 'pending
	dgok = false
	comok = false
		
	If GetFiles() and Canwestart() then
		m.mylog("Sucessfully copied autorun zip to root")
		DeleteFile("autorun.brs")
	else
		m.mylog("Failed to copy setup files from pool to root")
		
	endif
	

End Sub

Function Canwestart() as boolean
	slog = createobject("roSystemLog")
	slog.sendline("canwestart helper")

	auto = false
	mylist = matchfiles(".","*.zip")

	For each file in mylist
		print file
		If file ="autorun.zip" then auto = true
	Next
	
	print "auto: ";auto
	
	If auto then
		return true
	else
		return false
	endif

End Function

Function GetFiles() as Boolean
	slog = createobject("roSystemLog")
	slog.sendline("getfiles helper")
'2

runpath$=""
runpath$ = GetPoolFilePath(m.bsp.assetPoolFiles, "autorun.zip")

	if runpath$ <> "" then 
		okrun = Copyfile(runpath$, "autorun.zip")
		print "copied autorun: ";okrun
	else
		slog.sendline("One or more files didn't return a pool path")
		print "autorun found: ";okrun
	endif
	
	if okrun then
		return true
	else
		return false
	endif
	
end Function
