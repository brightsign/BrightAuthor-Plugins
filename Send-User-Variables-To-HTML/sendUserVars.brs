REM
REM @title               Send User Variables to an HTML widget
REM @author              Lee Dydo
REM @date-created        02/21/2017
REM @date-last-modified  02/21/2017
REM @minimum-FW          6.2.*
REM
REM @description         This plugin listens for "USER_VARIABLE_UPDATED" events
REM                      then sends all variables to the HTML widget through the PostJSMessage
REM                      method. Variables can be updated through the local server on port 8008
REM                      or through the BrightSign iPad app. Once updated, the variables are displayed
REM                      onscreen.
REM
Function sendUserVars_Initialize(msgPort As Object, userVariables As Object, bsp As Object)
  return {
    objectName :    "sendUserVars_object",
    msgPort :       msgPort,
    userVariables : userVariables,
    bsp :           bsp,
    htmlwidget:     invalid, ' We'll use the FindHTMLWidget method to set this later
    ProcessEvent :  Function (event As Object)

      if m.htmlwidget = invalid
        m.htmlwidget = FindHTMLWidget(m.bsp)
      endif
      ?event
      'Receive a plugin message
      if type(event) = "roAssociativeArray" then
        if type(event["EventType"]) = "roString"
          if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
            if event["PluginName"] = "sendUserVars" then
              pluginMessage$ = event["PluginMessage"]
              return true
            endif
          elseif event["EventType"] = "USER_VARIABLES_UPDATED" then
              ?"USER_VARIABLES_UPDATED"
              aa = {}
              for each key in m.userVariables
                aa[key] = m.userVariables[key].currentValue$
                m.htmlwidget.PostJSMessage(aa)
              next
          endif
        endif
      endif
      
      'Send a plugin message to other plugins and BrightAuthor Objects
      if (false) 'change this to your criterion for sending a message
        pluginMessageCmd = {}
        pluginMessageCmd["EventType"] = "EVENT_PLUGIN_MESSAGE"
        pluginMessageCmd["PluginName"] = "sendUserVars"
        pluginMessageCmd["PluginMessage"] = "empty"
        m.msgPort.PostMessage(pluginMessageCmd)
      endif
      return false
    End Function
  }
End Function


Function FindHTMLWidget(bsp)
    for each baZone in bsp.sign.zonesHSM
        if baZone.loadingHtmlWidget <> invalid then
            return baZone.loadingHtmlWidget
        end if
    end for
    print "Couldn't find htmlwidget"
    return false
End Function