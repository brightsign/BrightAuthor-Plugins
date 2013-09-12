Sub klog(xmlFileName$ as String, itemsByIndex as object, itemsByTitle as Object, userVariables As Object)

	debug=false
	log = CreateObject("roSystemLog").ReadLog()
	
	systemTime = CreateObject("roSystemTime")    
	myTime = systemTime.GetLocalDateTime()
	month = mid(str(mytime.getmonth()), 2)
	day = mid(str(mytime.getday()),2)
	year = mid(str(mytime.getyear()),2)
	date = month+day+year

	klogname = date+"kernel_log.txt"
	if debug print klogname
	
	f = CreateObject("roAppendFile", klogname)
	if type(f) <> "roAppendFile" then f = CreateObject("roCreateFile", klogname)
	print #f, log
	f = invalid
	if debug print "finished"

end Sub
