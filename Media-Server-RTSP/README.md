Overview
--------
<p>This Plugin converts an XD player to a Media Server that waits for clients to connect, and then starts streaming to them.  XD players Support up to four 19Mbps streams when the files being streamed are cached (i.e. they aren't being read from the SD card). The XD Media Server currently only supports MPEG-2 transport stream files.</p>

Details
-------------
<p>rtsp server, port 8090 (the port number can be changed if needed)</p>
<p>Streaming File from Client: rtsp://ServerIpAddress:8090/file:///folder/file.ts</p>
<p>rtsp://ServerIpAddress:8090/file:///file.ts</p>

Server Options
------------------
<p><em>Maxbitrate</em> - sets the maximum instantaneous bitrate of the RTP transfer initiated by RTSP. This has no effect for HTTP. The units are in Kbps; the parameter value 80000 (meaning 80Mbps) has been found to work well for streaming to XD players. The default behaviour (achieved by passing the value zero) is to not limit the bitrate at all.</p>

<p>Example: "rtsp:port=554&trace&maxbitrate=80000"</p>

<p><em>Threads</em> - Each thread handles one client; the default value is "5".</p>

<p>Example: "http:port=8080&threads=10"</p>
