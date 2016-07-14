REM
REM @title               Match the Frame Rate of the Video Currently Playing
REM @author              Lee Dydo
REM @date-created        04/13/2016
REM @date-last-modified  07/08/2016
REM @minimum-FW          6.1.58
REM
REM @description         This plugin discovers the probe data in the video file
REM                      via [roVideoPlayer].GetStreamInfo() and changes the
REM                      resolution on the video output to match on the fly.
REM
Function matchFrameRate_Initialize(msgPort As Object, userVariables As Object, o As Object)
  matchFrameRate = { }
  matchFrameRate.msgPort = msgPort
  matchFrameRate.userVariables = userVariables
  matchFrameRate.objectName = "matchFrameRate_object"
  matchFrameRate.ProcessEvent = matchFrameRate_ProcessEvent
  matchFrameRate.bsp = o
  return matchFrameRate
End Function

Function matchFrameRate_ProcessEvent(event As Object)
  if type(event) = "roVideoEvent" then
    streamInfoArr = m.bsp.getvideozone(0).videoplayer.GetStreamInfo()
    frameRate = str(cint(streamInfoArr.VideoFrameRate)).trim()
    xStr = stri(m.bsp.videoMode.getVideoResX()).trim()
    yStr = stri(m.bsp.videoMode.getVideoResY()).trim()
    modeToMatchResolution = xStr + "x" + yStr + "x" + frameRate + "p-noreboot"
    ?modeToMatchResolution
	m.bsp.videomode.setmode(modeToMatchResolution)
  endif
return false
End Function
