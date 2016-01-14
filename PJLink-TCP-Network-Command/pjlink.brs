' Based on PJLinkOn BrightSign Plugin by Tweaklab
' v1.00

Function pjlink_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
  print "pjlink_Initialize - entry"

  pjlink = newpjlink(msgPort, userVariables, bsp)

  return pjlink
End Function

Function newpjlink(msgPort As Object, userVariables As Object, bsp As Object)
  print "newpjlink"
  s = {}
  s.msgPort        = msgPort
  s.userVariables  = userVariables
  s.bsp            = bsp
  s.ProcessEvent   = pjlink_ProcessEvent

  s.projector_ip$  = ""
  s.projector_port = 4352
  s.debug          = true
  ' s.dlog           = pjlink_dlog

  ' SetParamsFromUserVariables(s, userVariables)
  ' set IP address from user variables
  if userVariables.DoesExist("pjlink_projector_ip") then
    myvariable = userVariables.Lookup("pjlink_projector_ip")
    if myvariable <> invalid then
      s.projector_ip$ = myvariable.GetCurrentValue()
      s.bsp.diagnostics.printdebug("set pjlink ip address: " + s.projector_ip$)
    endif
  endif

  ' set projector port
  if userVariables.DoesExist("pjlink_projector_port") then
    myvariable = userVariables.Lookup("pjlink_projector_port")
    if myvariable <> invalid then
      s.projector_port = myvariable.GetCurrentValue()
      s.bsp.diagnostics.printdebug("set pjlink port: "+s.projector_port)
    endif
  endif

  return s
End Function

Function pjlink_ProcessEvent(event As Object) as boolean
  print "pjlink_ProcessEvent"
  print "  type of message is: ";type(m)
  print "  type of event is: ";type(event)
  retval = false

  ' define the message "%1POWR 1" in HEX to power ON the projector
  ' %1POWR 1 = Power On
  ' projector_message$="2531504F575220310D0A"

  if type(event) = "roAssociativeArray" then
    if type(event["EventType"]) = "roString" then
      if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
        if event["PluginName"] = "pjlink" then
          pluginMessage$ = event["PluginMessage"]
          print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
          messageToParse$ = event["PluginName"]+"!"+pluginMessage$
          retval = pjlink_ParsePluginMsg(messageToParse$, m)
        endif
      endif
    endif
  elseif type(event) = "roDatagramEvent" then
    ' UDP Datagrams for pjlink!<command>
    msg$ = event
    if (left(msg$,6) = "pjlink") then
      retval = pjlink_ParsePluginMsg(msg$, m)
    endif
  endif

  return retval
End Function

Function pjlink_ParsePluginMsg(msg As string, s As Object) as boolean
  print "pjlink_ParsePluginMsg"
  retval = false

  r = CreateObject("roRegex", "^pjlink", "i")
	match = r.IsMatch(msg)
  if match then
    retval = true
    command = ""

    r2        = CreateObject("roRegex", "!", "i")
    fields    = r2.split(msg)
    numFields = fields.count()
    if (numFields < 2) or (numFields > 2) then
      s.bsp.diagnostics.printdebug("pjlink Incorrect number of fields for command:"+msg)
      return retval
    else
      ' numFields = 2
      if fields[1] = "poweron" then
        command = "2531504F575220310D0A"
      elseif fields[1] = "poweroff" then
        command = "2531504F575220300D0A"
      else
        ' append %1 and \r\n to the command
        ba = CreateObject("roByteArray")
        ba.FromAsciiString("%1" + fields[1] + Chr(13) + Chr(10))
        command = ba.ToHexString()
      endif
    endif
    ' s.bsp.diagnostics.printdebug("pjlink command found: " +command)
    print "pjlink command assigned: ";command
    retval = pjlink_SendProjectorMessage(command, s)
  endif

  return retval
End Function

Function pjlink_SendProjectorMessage(hex_msg as string, s As Object) as boolean
  print "Connecting to projector at ";s.projector_ip$; ":";s.projector_port

  sock=CreateObject("roTCPStream")
  if sock=invalid then
    print "Failed to create roTCPClient object"
    stop
  endif
  if sock.ConnectTo(s.projector_ip$, StrToI(s.projector_port)) then
    ' print "Connected"
    bytes = CreateObject("roByteArray")
    sleep(500)
    bytes.FromHexString(hex_msg)
    print "Sending PJLink message: ";hex_msg
    sock.SendBlock(bytes)
    return true
  else
    print "Failed to connect to projector"
    sock = invalid
  endif

  return false
End Function

' Sub pjlink_dlog (error$ as String)
'   m.bsp.logging.WriteDiagnosticLogEntry("99plgn", error$)
'   'm.bsp.diagnostics.printdebug(error$)
'   print error$
'   slog = createobject("roSystemLog")
'   slog.sendline(error$)
' End Sub
