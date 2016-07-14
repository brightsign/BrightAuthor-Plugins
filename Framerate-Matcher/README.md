<p>By default, a BrightAuthor presentation will maintain the same framerate (which is set by the <strong>Screen resolution</strong> of the presentation), ignoring the framerate of the video that is currently playing. You can use the Framerate Matcher plugin to make the framerate of the video output dynamic: whenever a new video begins playback, the video output will change to match the framerate of the video file.</p>
<p><strong>Note</strong>: <em>Players must be installed with firmware version 6.1.76 or later to use this plugin.</em></p>
<p><strong>Note</strong>: <em>The presentation can contain one video zone only.</em></p>
###Video Format Restrictions
<p>The plugin must be able to probe the framerate of the video file at runtime. This means that the plugin will only work with certain video formats:</p>
<ul>
<li>An MP4 container that defines the framerate in the MP4 encapsulation. Any video codec in the container will be supported as long as this condition is met.</li>
<li>The MPEG2-TS container</li>
<li>The H.265 Elementary Stream (ES) container</li>
</ul>
###Adding the Plugin to your Presentation
<p>Follow these steps to add the plugin to your BrightAuthor presentation:</p>
<ol>
<li>Navigate to <strong>File > Presentation Properties > Autorun</strong>.</li>
<li>Click <strong>Add Script Plugin</strong>.</li>
<li>Locate and select the matchFrameRate.brs plugin file.</li>
<li>Specify the plugin Name as "matchFrameRate".</li>
</ol>
