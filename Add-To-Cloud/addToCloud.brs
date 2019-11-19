REM
REM @title               addToCloud Plugin
REM @author              Lee Dydo
REM @date-created        11/15/2019
REM @date-last-modified  11/15/2019
REM @minimum-FW          1.0.0
REM
REM @description         Add this plugin to a presentation for players using BrightAuthor Classic
REM                      to add those players to content cloud or control cloud.
REM
Function addToCloud_Initialize(msgPort As Object, userVariables As Object, bsp As Object)
  REM <<< Parse the JSON
  values = invalid
  file = createObject("roReadFile", "cloudParams.json")
  if file <> invalid
    jsonString = ""
    while NOT file.atEOF()
      jsonString = jsonString + file.readLine()
    endwhile
    values = ParseJSON(jsonString)
  endif 
  REM Parse the JSON >>>
  
  REM <<< Write the registry
  net = createObject("roRegistrySection", "networking")
  if net.read("setBaconVals") = "" AND values <> invalid
    for each key in values
      if type(values[key]) = "String"
        net.write(key, values[key])
      endif
    next
    net.flush()
    REM Write the registry >>>

    REM <<< Kick off recovery if content cloud is enabled
    if values <> invalid AND values.contentCloud <> invalid AND values.contentCloud
      deleteFile("autorun.brs")
    endif
    REM Kick off recovery if content cloud is enabled >>>
    
    rebootSystem()
  endif

  return {
    ProcessEvent  : Function (event As Object)
        return false 'This plugin does not process events
    End Function
  }
End Function

