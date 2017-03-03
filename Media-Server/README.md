Overview
--------
<p>This plugin converts an XT, XD, 4K player to a Media Server that can multicast streams or respond to client streaming requests. When the files being streamed are cached (i.e. they aren't being read from the SD card), XDx30, XDx32 players support up to four 19Mbps streams. XT, 4K, and XDx33 players support up to 50 19Mbps streams of the same file or 11 streams (16Mbps average) of different files.</p>
<p>When file streaming, the Media Server currently only supports the MPEG-2 transport stream format.</p>

###Requirements
<ul>
<li>BrightAuthor version 4.3 or newer</li>
<li>XTx43, XDx33, 4Kx42, XDx32 for streaming the presentation display or HDMI input</li>
</ul>

Adding the Plugin to your Presentation
-------------
<p>Follow these steps to add this plugin to your BrightAuthor presentation:</p>
<ol>
<li>Navigate to <strong>File > Presentation Properties > Autorun</strong>.</li>
<li>Click <strong>Add Script Plugin</strong>.</li>
<li>Locate and select the Streaming Server plugin.</li>
<li>Specify the plugin <strong>Name</strong> as "server".</li>
</ol>

Server Parameters
-------------
<p>When the presentation starts, the plugin will begin serving files automatically from the player. You can alter the default behavior by changing the following parameters in the plugin script:</p>
<ul>
<li><code>s.streamdisplayenabled = false</code>: Set to <code>true</code> to stream the presentation display.</li>
<li><code>s.hdmioutenabled = false</code>: Set to <code>true</code> to stream HDMI input.</li>
<li><code>s.hdmimultienabled = false</code>: Set to <code>true</code> to stream HDMI input via multicast.</li>
</ul>
<p><strong>Note</strong>: If all of the above values are false, then clients will stream video files from the server.</p>
### Encoder Settings
<p>To edit the standard HDMI input streaming, change this value:</p>
<p><code>pipleline$="hdmi:,encoder:vformat=720p60&vbitrate=8000,"</code></p>

<p>To edit multicast HDMI input streaming, change this value:</p>
<p><code>pipelineaddress$ = "hdmi:,encoder:vformat=720p30&vbitrate=8000,"+m.multicast$</code></p>

<p>To edit presentation display streaming, change this value:</p>
<p><code>display:mode=1&vformat=720p30&vbitrate=8000,encoder:,mem:/display</code></p>

<p>The following parameters can be changed:</p>
<ul>
<li><code>vformat</code>: Can be 720p30 or 1080p60.</li>
<li><code>vbitrate</code>: Can range from 8000 to 15000 (8mbps to 15mbps).</li>
</ul>

###Multicast address
<p>To set the multicast streaming address, edit the string value of the <code>s.multicast$</code> variable on line 53:</p>
<p><code>s.multicast$ = "rtp://239.192.0.0:5004/"</code></p>

Streaming URLs
------------------
###Accessing a file stream from a client
<p><code>rtsp://ServerIpAddress:8090/file:///folder/file.ts</code></p>
<p><code>rtsp://ServerIpAddress:8090/file:///file.ts</code></p>
###Accessing an HDMI-input stream from a client
<code>rtsp://serverIPAddress:8090/mem:/hdmi/stream.ts</code>
###Acessing a display stream from a client
<code>rtsp://serverIPAddress:8090/mem:/display/stream.ts</code>
