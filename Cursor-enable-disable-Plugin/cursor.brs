REM
REM @title               Cursor enable/disable Plugin
REM @author              Mikhail Potyomkin
REM @date-created        12/18/2019
REM @date-last-modified  12/18/2019
REM @minimum-FW          1.0.0
REM
REM @description         This is a plugin for enable or disable cursor.
REM                      You can send message to this plugin "cursor!true" or "cursor!false"
REM                      Also you can create variable "cursor", value will be changeble "true" or "false"
REM

Function cursor_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
  print "Cursor initialize"

  s = {}
  s.version = 0.1
  s.msgPort = msgPort
  s.userVariables = userVariables
  s.bsp = bsp
  s.ProcessEvent = Cursor_ProcessEvent
  s.objectName = "cursor_object"
  s.debug  = true

  myVar = "cursor"

  if s.userVariables.DoesExist(myVar) then

    DisplayMode$ = s.bsp.sign.touchCursorDisplayMode$
    cursor = s.userVariables.Lookup(myVar)

    if DisplayMode$ = "display" then
      cursor.SetCurrentValue("true",true)
    else if DisplayMode$ = "hide" then
      cursor.SetCurrentValue("false",true)
    end if

  end if


  return s
End Function

function Cursor_ProcessEvent(event As Object) as boolean
  'print "Cursor_ProcessEvent"  
  retval = false

  if type(event) = "roAssociativeArray" then
    if type(event["EventType"]) = "roString" then
      if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
        if event["PluginName"] = "cursor" then

          pluginMessage$ = event["PluginMessage"]
          'print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$                    
          retval = ParseCursorPluginMsg(pluginMessage$, m)

        endif
      endif
    endif
  end if

  return retval

End Function


Function ParseCursorPluginMsg(origMsg as string, s as object) as boolean
  retval  = false
  command = ""
  myVar = "cursor"
    
  ' convert the message to all lower case for easier string matching later
  msg = lcase(origMsg)
  'print "Received Plugin message: "+msg
  r = CreateObject("roRegex", "^cursor", "i")
  match=r.IsMatch(msg)

  if match then
    retval = true

    ' split the string
    r2 = CreateObject("roRegex", "!", "i")
    fields=r2.split(msg)
    numFields = fields.count()
    if (numFields < 2) or (numFields > 2) then
      s.bsp.diagnostics.printdebug("Incorrect number of fields for cursor command:"+msg)
      return retval
    else if (numFields = 2) then
      command=fields[1]
    end if
  end if


  if command = "true" then

    s.bsp.sign.touchCursorDisplayMode$ = "display"
    s.bsp.touchScreen.EnableCursor(true)
    
    if s.userVariables.DoesExist(myVar) then
      cursor = s.userVariables.Lookup(myVar)
      cursor.SetCurrentValue("true",true)
    end if

  else if command = "false" then
    s.bsp.sign.touchCursorDisplayMode$ = "hide"
    s.bsp.touchScreen.EnableCursor(false)
    if s.userVariables.DoesExist(myVar) then
      cursor = s.userVariables.Lookup(myVar)
      cursor.SetCurrentValue("false",true)
    end if
  endif
  
  return retval
end Function
