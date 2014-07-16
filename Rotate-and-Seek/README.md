Overview
---------
<p>This plugin allows you to rotate a video or seek to a certain position in a video. These actions can be triggered using Plugin Message commands or UDP commands on port 555.</p>

<p>When adding this plugin to your BrightAuthor project in <strong>File > Presentation Properties > Autorun</strong>, ensure that the plugin <strong>Name</strong> is specified as "custom".</p>

Rotate
------
<p>To trigger a rotation, the Plugin Message or UDP command must be formatted as follows:</p>
<code>rotate![zone_name]![rotate_type]</code>

<p><strong>zone_name</strong>: The name of the video zone you wish to rotate.</p>
<p><strong>rotate_type</strong>: The type of video rotation to be performed. The following parameters can be used:</p>
<ul>
<li>r90: 90 degree clockwise rotation</li>
<li>r180: 180 degree rotation</li>
<li>r270: 270 degree clockwise rotation</li>
<li>mirror: Horizontal mirror transformation</li>
<li>m90: Mirrored 90 degree clockwise rotation</li>
<li>m180: Mirrored 180 degree clockwise rotation</li>
<li>m270: Mirrored 270 degree clockwise rotation</li>
</ul>
<p><strong>Example:</strong>: The following command rotates a zone named "main" by ninety degrees.</p>
<code>rotate!main!r90</code>


Seek
------
<p>To trigger a seek, the Plugin Message or UDP command must be formatted as follows:</p>
<code>seek![zone_name]![video_position]</code>

<p><strong>zone_name</strong>: The name of the video zone containing the video you wish to perform seek on.</p>
<p><strong>video_position</strong>: The position (in milliseconds) to seek to in the current video. The seek will not occur if the position is past the end of the video file.</p>

<P><strong>Example</strong>: The following command seeks to 2500 milliseconds in the current video file in the "main" zone:</p>
<code>seek!main!2500</code>
