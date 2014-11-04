'v.3

Function Custom_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "Custom_Initialize - entry"
    print "type of msgPort is ";type(msgPort)
    print "type of userVariables is ";type(userVariables)

    Custom = newCustom(msgPort, userVariables, bsp)
	
    return Custom

End Function



Function newCustom(msgPort As Object, userVariables As Object, bsp as Object)
	print "initCustom"

	
	' Create the object to return and set it up
	
	s = {}
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = Custom_ProcessEvent
	s.vm=CreateObject("roVideoMode")
	s.DisplaySubs = DisplaySubs
	s.GetEOL = GetEOL
	s.TimeintoMs = TimeintoMs
	s.ParseSubs =ParseSubs
	s.HandleVideoEventPlugin = HandleVideoEventPlugin
	s.GetCurrentStateName = custom_GetCurrentStateName
	s.TheStore = CreateObject("roAssociativeArray")
	s.TheStore.timeArray = CreateObject("roArray", 1, true)
	s.TheStore.SubtitleArray = CreateObject("roArray", 1, true)
	s.id = 0
	s.subItems = 0
	s.x = s.vm.GetSafeX()
	s.y = s.vm.GetSafeY()
	s.w = s.vm.GetSafeWidth()
	s.h = s.vm.GetSafeHeight()
	s.EnglishSub = CreateObject("roArray",1,true)
	s.rect=CreateObject("roRectangle", s.x+10, s.y+s.h-90, s.w-20, 80)
	s.text=CreateObject("roTextWidget", s.rect, 2, 2, 0)
	s.text.SetBackgroundColor(&h80000000)
	s.ParsedAlready = true
	s.text.Show()
	s.objectName = "Subtitle_object"

	return s

End Function



Function GetEOL(file as String)

	eol = chr(13) + chr(10)   '/r/n, Windows/DOS File
	if instr(1, file, eol) = 0 then
		eol = chr(13)   '/r, Mac
		if instr(1, file, eol) = 0 then
			eol = chr(10)   '/n, Linux
			if instr(1, file, eol) = 0 then
				eol = chr(13) + chr(10)   '/r/n, Windows/DOS File
			endif
		endif
	endif

	'eoln = len(eol)
	
	
	return eol


End Function


Function TimeintoMs(time as string)
	
	hp= 0
	mp=instr(hp, time, ":")+1
	sp=instr(mp+1, time, ":")+1
	fp=instr(sp+1, time, ":")+1

	hours = val(mid(time, hp, mp - 1))
	minutes = val(mid(time, mp, sp - mp - 1))
	seconds = val(mid(time, sp, fp - sp - 1))
	frames = val(mid(time, fp, 2))

	time_in_ms = (((((hours * 60) + minutes) * 60) + seconds) * 1000) + (frames * 1000 / 30)

	return time_in_ms
	
End Function


Function ParseSubs()

	m.id = 0	'new
	m.subItems = 0	'new
	m.TheStore.SubtitleArray.clear()	'new
	m.TheStore.timeArray.clear()	'new
				
	SubtitleFilePath$ = GetPoolFilePath(m.bsp.assetPoolFiles, m.GetCurrentStateName())	'new
	
	'print"!!!!SubtitleFilePath$: !!!!!" SubtitleFilePath$
	
	'filename = "subtitles.txt"
	'file = ReadAsciiFile(filename)
	file = ReadAsciiFile(SubtitleFilePath$)
	eol = GetEOL(file)
	eoln = len(eol)
	print "debug text file: "; SubtitleFilePath$
	
	Pos_t = 0
	index_t = 0
	Pos_s = 0
	index_s = 0	
	time = ""
	Subtitle = ""
	m.TheStore.timeArray.push(time) 
	'do we need to reset timearray
	'******************************

	While index_s <= len(file)	

       Pos_t = instr(index_t, file, eol) + eoln
	   time = mid(file, index_t, Pos_t - index_t - 1)
	   index_s = Pos_t
		
		m.TheStore.timeArray.push(time) 
		
		FormattedTime = m.TimeintoMs(time)
		
		eventx = m.bsp.sign.zoneshsm[0].videoplayer.AddEvent(m.id, FormattedTime)
		
		print "!!!Eventx!!!!!" eventx;FormattedTime
		
			Pos_S = instr(index_s, file, eol) + eoln
			subtitle = mid(file, index_s, Pos_S - index_s - eoln)
			
			'print subtitle
			m.TheStore.SubtitleArray.push(subtitle)
						
			m.id = m.id + 1
			
			m.subItems = m.subItems + 1
			
			index_t = Pos_S
				
		
	End while

	'stop
	
End Function	

	
	
 Function Custom_ProcessEvent(event As Object) as boolean

	retval = false
    print "Custom_ProcessEvent - entry"
    print "type of m is ";type(m)
    print "type of event is ";type(event)

	if type(event) = "roVideoEvent" then	
		
		retval = HandleVideoEventPlugin(event, m)
	
	end if
	
	'debug
	
	return retval

End Function
	

Function HandleVideoEventPlugin(origMsg as Object, Custom as Object) as boolean

	if type(origMsg) = "roVideoEvent" then
	
		print "origMsg: ";origMsg.GetInt()

		
		'stop
		if origMsg.GetInt() = 3 then
		
			'print"I'm about to go parsing"
			Custom.ParseSubs()
		
		else if origMsg.GetInt() = 12 then
		
			id = origMsg.GetData()
			
			'print "TimeCode event Received" id
			
			Custom.DisplaySubs(id)
			
		else if origMsg.GetInt() = 8 then
		
			print "Video End Event Received"
			
				Custom.id = 0
				Custom.subItems = 0
		
		
		endif
	
	end if

End Function



Function DisplaySubs(id as integer)
	
  'print "inside DisplaySubs"
	
  'print "m.id in Display sub is " id
  
  m.text.PushString(m.TheStore.SubtitleArray[id])
  
  m.text.Show()
  
End Function


Function custom_GetCurrentStateName() as String
'assumes the current state is the main state with video playback

	print "checking for active state/file name"
	'print m.bsp.sign.zoneshsm[0].activestate.name$
	
	name$=m.bsp.sign.zoneshsm[0].activestate.name$
	lname= len(name$)
	tpos = instr(1, name$, ".")
	fname$ = left(name$, tpos)
	fullname$ = fname$+"txt"
	
	print "debug getcurrentstatename: "; fullname$
	return fullname$
	
end Function
