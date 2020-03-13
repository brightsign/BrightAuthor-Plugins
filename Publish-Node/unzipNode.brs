REM
REM @title               unzipNode Plugin Template
REM @author              Lee Hardy Dydo
REM @date-created        02/12/2020
REM @date-last-modified  02/12/2020
REM @version             0.0.1
REM @minimum-FW          8.0.*
REM
REM @description         This plugin unzips and then boots up a chronode application.
REM
REM
Function unzipNode_Initialize(msgPort As Object, userVariables As Object, bsp As Object)

  zipFilePath =  GetPoolFilePath(bsp.assetPoolFiles, "node.zip")
  oldZip = readAsciifile("node/hash")

  if zipFilePath <> oldZip
    ? "Unzipping Node Application"
    serverPackage = createObject("roBrightPackage", zipFilePath)
    if type (serverPackage) = "roBrightPackage"
      createDirectory("node")
      serverPackage.unpack("node/")
      writeAsciiFile("node/hash", zipFilePath)
    endif
  else
    ? "Node zip hashes match, no need to unzip servers"
  endif
  
  ?"Initializing Node."
  r = createObject("roRectangle",0,0,1920,1080)
  aa = {
    nodejs_enabled : true,
    brightsign_js_objects_enabled : true,
    url : "file:///node/index.html",
    inspector_server: {
      port : 2999
    },
    security_params : {
      insecure_https_enabled: true,
      websecurity: false,
      camera_enabled: false
    },
    focus_enabled: true,
    javascript_enabled: true,
    storage_path: "SD:",
    storage_quota: 1073741824
  }
  hw = CreateObject("roHTMLWidget", r, aa)
  hw.setPort(msgPort)
  
  hw.show()

  return {
    objectName      : "unzipNode_object",
    msgPort         : msgPort,
    userVariables   : userVariables,
    bsp             : bsp,
    hw              : hw
    ProcessEvent    : Function (msg As Object)
      print "type(msg)=";type(msg)
      if type(msg) = "roHtmlWidgetEvent" then
        eventData = msg.GetData()
        if type(eventData) = "roAssociativeArray" and type(eventData.reason) = "roString" then
          print "reason = ";eventData.reason
          if eventData.reason = "load-error" then
            print "message = ";eventData.message
          endif
        endif
      endif
      return false
    End Function
  }
End Function
