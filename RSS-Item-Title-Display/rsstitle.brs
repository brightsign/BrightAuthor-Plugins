Sub rsstitle(xmlFileName$ as String, itemsByIndex as object, itemsByTitle as Object, userVariables As Object)

	xml = CreateObject("roXMLElement")
	if not xml.Parse(ReadAsciiFile(xmlFileName$)) then 
		print "xml read failed"
	else
		if type(xml.channel.item) = "roXMLList" then
			index% = 0
			for each itemXML in xml.channel.item
				itemsByIndex.push(itemXML.title.GetText())
				index% = index%+1
			next
		endif
	endif
	
		DeleteFile(xmlfilename$)	
end Sub
