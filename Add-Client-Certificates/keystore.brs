Function keystore_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "keystore_Initialize - entry"

    keystore = newkeystore(msgPort, userVariables, bsp)
    keystore.findkey()	
	
    return keystore

End Function


Function newkeystore(msgPort As Object, userVariables As Object, bsp as Object)
	print "newkeystore"

	s = {}
	s.version = 0.2
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = keystore_ProcessEvent
	s.Findkey = keystore_Findkey
	s.Addkey = keystore_Addkey
	s.keychecked = false
	s.objectName = "keystore_object"
	s.debug  = true
	
	s.Findkey()	'checks immediately
	
	return s
End Function

Sub keystore_Findkey()
	cert$=""
	certlocation$=""

	if m.userVariables.DoesExist("cert") then
		myvariable = m.userVariables.Lookup("cert")
		if myvariable <> invalid then 
			cert$ = myvariable.GetCurrentValue()
			dlog("Cert Variable found: "+cert$)
	
			if cert$ <> "" then
				'lookup file and pass name to keystore_Addkey
				certlocation$ = GetPoolFilePath(m.bsp.assetPoolFiles, cert$)
				
				if certlocation$ <> "" then
					dlog("Found Cert: "+certlocation$)
					m.Addkey(certlocation$)
				else
					dlog("Cert file not found in pool, checking root location")
					certlocation$ = cert$
					m.AddKey(certlocation$)				
				endif
				
			else
				dlog("Certain Variable Empty")
			endif
		else
			dlog("no cert variable found")
		endif
	endif
End Sub


Function keystore_ProcessEvent(event As Object) as boolean
	retval = false

	if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString" then
             if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
                if event["PluginName"] = "keystore" then
                    pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
                    retval = ParsekeystorePluginMsg(pluginMessage$, m)
                endif
            endif
        endif
	else if type(event) = "roDatagramEvent" then

	else if (type(event) = "roUrlEvent") then

	else if type(event) = "roHttpEvent" then

	else if type(event) = "roTimerEvent" then

	end if

	return retval

End Function



Function ParsekeystorePluginMsg(origMsg as string, s as object) as boolean

	retval  = false
	command = ""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^keystore", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			print "Incorrect number of fields for keystore command:";msg
			return retval
		else if (numFields = 2) then
			command=fields[1]
		end if
	end if
	
	if command = "debug" then
	    s.debug=true
	end if

	return retval
end Function


sub dlog(message$ as string)
	slog = createobject("roSystemLog")
	slog.sendline(message$)
	'm.bsp.logging.WriteDiagnosticLogEntry("99plgn", (message$)
	'm.bsp.diagnostics.printdebug(message$)
	'if m.debug print (message$)
end sub

Sub keystore_Addkey(cert$ as string)
	k=createobject("rokeystore")
	ok = k.addcacertificate(cert$)
	if ok then 
		dlog("successfully added certificate")
	else
		dlog("Failed to add certificate: "+cert$)	
	endif
end Sub


Sub keystore_AddPkey(pcert$ as string)
	k=createobject("rokeystore")

		'AddClientCertificate(parameters As roAssociativeArray) As Boolean
		'Registers a .p12 client certificate with the certificate database. This method accepts an associative array with the following parameters:
		'certificate_file: The file name and path of the .p12 client certificate.
		'passphrase: A passphrase for the .p12 client certificate.
		'obfuscated_passphrase: An obfuscated passphrase for the .p12 client certificate.

	aa = CreateObject("roAssociativeArray")
	aa.AddReplace("certificate_file", pcert$)
	aa.AddReplace("passphrase", "1q2w3e4r")	'use obfuscated password instead
	ok = k.addclientcertificate(aa) 

		'Registers the specified CA certificate with the certificate database. Client certificates can 
		'be either self-signed or signed using a 3rd-party certificate issuer (Versign, DigiCert, etc.). 
end Sub
