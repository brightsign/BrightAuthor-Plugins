Sub urlchange(xmlFileName$ as String, itemsByIndex as object, itemsByTitle as Object, userVariables As Object)

	debug=true
	xml1 = CreateObject("roXMLElement")
		
	'1 get serial number
	modelObject = CreateObject("roDeviceInfo")
	myserial$ = ucase(modelObject.GetDeviceUniqueId())
	ziplisturl$=" "
	myzip$=" "
	ziplist$="zip.xml"

	
	'2 lookup ziplist location url
	if userVariables.DoesExist("ziplistlocation") then
		myvariable = userVariables.Lookup("ziplistlocation")
		If myvariable <> invalid ziplisturl$ = myvariable.GetCurrentValue()
		if debug print ziplisturl$
	endif
	
	if ziplisturl$ <> " " then	
		xfer=createobject("roURLTransfer")
		if xfer <> invalid then
			xfer.seturl(ziplisturl$)
			xfer.GetToFile(ziplist$)
			xfer=0
		endif
		
			if not xml1.Parse(ReadAsciiFile(ziplist$)) then 
				if debug print "ziplist read failed"
			else
					if debug print myserial$
					if debug print xml1
					
				For each item in xml1.channel.item
					if debug print item.title.Gettext()
					if ucase(item.title.GetText()) = myserial$ then
						myzip$=item.description.GetText()
						if debug print "my zipcode:"; myzip$
						
							'3 set zip code
							if userVariables.DoesExist("zipcode") then
								myvariable = userVariables.Lookup("zipcode")
								If myvariable <> invalid myvariable.SetCurrentValue(myzip$, true)
							endif
						exit for
					endif
				next
			endif
	endif

		DeleteFile(xmlfilename$)	
end Sub
