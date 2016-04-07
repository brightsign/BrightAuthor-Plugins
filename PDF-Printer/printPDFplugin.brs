REM
REM @title                   PDF Printer
REM @author                  Lee Dydo
REM @company                 BrightSign LLC.
REM @date-created            04/06/2016
REM @date-last-modified      04/07/2016
REM


REM
REM This is the constructor function for out plugin object
REM
Function printPDF_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

  ' Create the plugin object to return and set it up
  h = {}
  h.version = "1.00.00"
  h.msgPort = msgPort
  h.userVariables = userVariables
  h.bsp = bsp
  h.ProcessEvent = printPDF_ProcessEvent
  h.streamPDFtoPrinter = streamPDFtoPrinter
  h.copiedFilesToprintPDF = false
  return h

End Function

REM
REM This function is our event handler for our plugin message.
REM In the BrightAuthor presentation, we send a "printPDF" plugin message
REM from the advanced commands of the [Print!] state.
REM
Function printPDF_ProcessEvent(event As Object) as boolean
retVal = false
  if type(event) = "roAssociativeArray" then
    if type(event["EventType"]) = "roString"
      if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
        if event["PluginName"] = "printPDF" then
          pluginMessage$ = event["PluginMessage"]
          if pluginMessage$ = "printFiles" then
            m.streamPDFtoPrinter(m.userVariables.printerIP.currentvalue$)
            pluginMessageCmd = CreateObject("roAssociativeArray")
            pluginMessageCmd["EventType"] = "EVENT_PLUGIN_MESSAGE"
            pluginMessageCmd["PluginName"] = "printPDF"
            pluginMessageCmd["PluginMessage"] = "printPDFsFinishedEvent"
            m.msgPort.PostMessage(pluginMessageCmd)
            retVal = true
          end if
        end if
      end if
    end if
  end if
return retVal

End Function

REM
REM This subroutine takes the IP address of the printer that's on our network
REM and opens a TCP socket to it, piping one byte of the PDF at a time.
REM
Sub streamPDFtoPrinter(printerIpAddress)

  stream = createObject("roTCPStream")
  if(stream.connectto(printerIPAddress,9100))
    for each additionalPublishedFile in m.bsp.additionalPublishedFiles
      fileName$ = additionalPublishedFile.fileName$
      source = additionalPublishedFile.filePath$
      reader = createObject("roReadFile", source)
      byteRead = reader.readbyte()
      while (byteRead >= 0)
        stream.sendbyte(byteRead)
        byteRead = reader.readByte()
      endwhile
    next
  end if
  print "=== Copy complete"
  m.copiedFilesToprintPDF = true

End Sub
