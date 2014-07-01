Overview
---------

<p>This plugin plays an audio file over HDMI whenever a touch event is triggered in the presentation.</p>

Specifying an Audio File
---------------------------
<p>By default, the plugin will play an audio file named "ping.mp3" when triggered. If you wish to use an audio file with a different name, change the "ping.mp3" filename strings on lines 27 and 51 of the plugin. 
<p>Once the plugin has been added, add the desired audio file to the presentation using the using the <strong>Add Files</strong> option in the <strong>File > Presentation Properties > File</strong> window.</p>

Changing the Audio Output
-------------------------
<p>By default, the audio file is only output over HDMI, but the output configuration can be customized in the plugin</p>
<ul>
<li>To add additional audio outputs, add one or more of the following entries after line 111: <code>CreateObject("roAudioOutput", [output])</code>, where <code>[output]</code> is one of the following: "Analog", "SPDIF", or "USB".
<li>To remove HDMI audio output, change the text of line 111 from <code>CreateObject("roAudioOutput","HDMI")</code> to <code>CreateObject("roAudioOutput","NONE")</code>.</li>
