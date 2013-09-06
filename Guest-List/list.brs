Sub list(xmlFileName$ as String, itemsByIndex as object, itemsByTitle as Object, userVariables As Object)

	xml1 = CreateObject("roXMLElement")
	if not xml1.Parse(ReadAsciiFile(xmlfilename$)) then 
			print "xml read failed"
	else
			temp_list_size=val(xml1@total)
			if temp_list_size >= 1 then 
				count=-1
				itemsByIndex.Clear()
				For each item in xml1.customer
					count=count+1
					itemsbyindex[count]=str(count+1)+". "+item.firstname.GetText() +" "+item.lastname.GetText()
				next
				
				if itemsbyindex.count() > count-1 then 
					print "clearing end of list"
					for d=count+1 to itemsByindex.count()-1
						itemsbyindex[d]=" "
					next
				else
					print "No entries to erase"
				endif


			endif
		DeleteFile(xmlfilename$)
	endif
	
end Sub
