REM
REM @title               htmlZoneMessage
REM @author              Lee Dydo
REM @date-created        04/28/2017
REM @date-last-modified  04/28/2017
REM @minimum-FW          1.0.0
REM
REM @description         This plugin allows you to send and receive zone messages from HTML.
REM
REM
Function htmlZoneMessage_Initialize(msgPort As Object, userVariables As Object, bsp As Object)
  return {
    objectName    : "htmlZoneMessage_object",
    msgPort       : msgPort,
    userVariables : userVariables,
    bsp           : bsp,
    ProcessEvent  : Function (event As Object)
      'Receive a plugin message
      ? "Event Received: "
      ? event
      if (type(m.htmlWidget) <> "roHTMLWidget")
        m.htmlWidget = findHTMLWidget(m.bsp)
      endif
      if type(event) = "roAssociativeArray" then
        ? "EEEEVENT"
        if type(event["EventType"]) = "roString"
          if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
            if event["PluginName"] = "htmlZoneMessage" then
              pluginMessage$ = event["PluginMessage"]
              'return true when you want no other event processors to handle this event
              return true
            endif
          else if event["EventType"] = "SEND_ZONE_MESSAGE" then
            'stop
            m.htmlwidget.postJSMessage({zoneMessage:event["EventParameter"]})
          endif
        endif
      else if type(event) = "roHtmlWidgetEvent" then
        ? "WIDGET EVENT"
        eventData = event.getData()
        if eventData["reason"] = "message" then
            ? "MESSAGE"

            if type(eventData) = "roAssociativeArray" and type(eventData.reason) = "roString" then
              if eventData.reason = "message" then
                if type(eventData.message.htmlready) = "roString"
                      ? "HTML Ready"
                else if type(eventData.message.button) = "roString"
                  parameter =  eventData.message.button
                  zoneMessageCmd = {
                              eventType : "SEND_ZONE_MESSAGE",
                              eventParameter : parameter
                              }
                  m.msgPort.PostMessage(zoneMessageCmd)
                endif
              endif
            endif


        endif
      endif



      'Send a plugin message to other plugins and BrightAuthor Objects
      if (false)
        pluginMessageCmd = {
          EventType    : "EVENT_PLUGIN_MESSAGE",
          PluginName   : "htmlZoneMessage",
          PluginMessage: "empty"
        }
        m.msgPort.PostMessage(pluginMessageCmd)
      endif

      'return false if another plugin or event processor should get a chance to handle this event
      return false
    End Function,
    htmlWidget  : FindHTMLWidget(bsp)
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