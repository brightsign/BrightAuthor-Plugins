REM
REM @title               Blank Plugin Template
REM @author              Lee Dydo
REM @date-created        03/15/2017
REM @date-last-modified  03/15/2017
REM @minimum-FW          1.0.0
REM
REM @description         This is a template for writing a new plugin.
REM                      Do a find-replace on the string "blank" and start writing your own!
REM
Function blank_Initialize(msgPort As Object, userVariables As Object, bsp As Object)
  return {
    objectName    : "blank_object",
    msgPort       : msgPort,
    userVariables : userVariables,
    bsp           : bsp,
    ProcessEvent  : Function (event As Object)
      'Receive a plugin message
      if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
          if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
            if event["PluginName"] = "blank" then
              pluginMessage$ = event["PluginMessage"]
              'return true when you want no other event processors to handle this event 
              return true
            endif
          endif
        endif
      endif

      'Send a plugin message to other plugins and BrightAuthor Objects
      if (false)
        pluginMessageCmd = {
          EventType    : "EVENT_PLUGIN_MESSAGE",
          PluginName   : "blank",
          PluginMessage: "empty"
        }
        m.msgPort.PostMessage(pluginMessageCmd)
      endif

      'return false if another plugin or event processor should get a chance to handle this event
      return false
    End Function
  }
End Function
