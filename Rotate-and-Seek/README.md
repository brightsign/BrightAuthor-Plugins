Overview
---------
<p>This plugin allows you to rotate a video or seek to a certain position in a video. It also allows you to create a Ticker zone with smooth scrolling text. All these actions can be triggered using Plugin Message commands or UDP commands on port 555.</p>

<p>When adding this plugin to your BrightAuthor project in <strong>File > Presentation Properties > Autorun</strong>, ensure that the plugin <strong>Name</strong> is specified as "custom".</p>

Rotate
------
<p>To trigger a rotation, the Plugin Message or UDP command must be formatted as follows:</p>
<code>rotate![zone_name]![rotate_type]</code>
<br>
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
<p><strong>Example</strong>: The following command rotates a zone named "main" by ninety degrees.</p>
<code>rotate!main!r90</code>

Seek
------
<p>To trigger a seek, the Plugin Message or UDP command must be formatted as follows:</p>
<code>seek![zone_name]![video_position]</code>

<p><strong>zone_name</strong>: The name of the video zone containing the video you wish to perform seek on.</p>
<p><strong>video_position</strong>: The position (in milliseconds) to seek to in the current video. The seek will not occur if the position is past the end of the video file. The position can also include a leading + or - character to indicate that the position is an offset from the current playback postion. For example:</p>
<code>seek![zone_name]!+5000</code>

<p>would seek 5 seconds forward in the current video.

<p><strong>Example</strong>: The following command seeks to 2500 milliseconds in the current video file in the "main" zone:</p>
<code>seek!main!2500</code>

Speed
--------
<p>Use one of the following Plugin Message or UDP commands to alter playback speed:</p>
<code>speed!playback_speed</code>
<code>speed!zone_name!playback_speed</code>
<br>
<p>The <code>playback_speed</code> value can be used to do the following:</p>
<ul>
  <li>Play forward in slow motion: 0 < playback_speed < 1.0</li>
  <li>Play forward at normal speed: playback_speed = 1.0</li>
  <li>Play forward in fast motion: 1.0 < playback_speed</li>
  <li>Play backward in slow motion: -1.0 < playback_speed < 0</li>
  <li>Play backward at normal speed: playback_speed = -1.0</li>
  <li>Play backward in fast motion: -1.0 > playback_speed</li>
</ul>
<p>For example, to play video at half speed, set the <code>playback_speed</code> to .5; to rewind the video at twice normal speed, set the <code>playback_speed</code> to -2.0.</p>

fade
------
<p>Use one of the following Plugin Message or UDP commands to set the video to fade out:</p>
<code>fade!fade_duration</code>
<code>fade!zone_name!fade_duration</code>
<br>
<p>The <code>fade_duration</code> is specified as an integer value of milliseconds.</p>

Scrolling Ticker
---------------
<p>Use the following Plugin Message or UDP command to initialize a Ticker zone with scrolling text:</p>
<code>ticker!scroll!x!y!w!h</code> 
<br>
<p>The <code>x</code> and <code>y</code> parameters specify the coordinates of the top left corner of the zone, while the <code>w</code> and <code>h</code> parameters represent the width and height of the zone. Note that the Ticker zone is created by the plugin; you do not need to use the <strong>Edit > Layout</strong> tab in BrightAuthor.</p>

Once the Ticker zone is initialized, you can use the following commands to configure and display the zone:
<ul>
<li><code>ticker!show</code>: Displays the Ticker zone.
<li><code>ticker!add!text</code>: Adds the <code>text</code> to the list of strings displayed by the scrolling ticker.
<li><code>ticker!message.txt</code>: Scrolls the contents of the <em>message.txt</em> file that is included with the presentation (miscellaneous files can be added to a presentation using the <strong>File > Presentation Properties > Files</strong> tab). Note that this command clears all other strings that have been added to the scrolling ticker.
<li><code>ticker!hide</code>: Hides the ticker from view. It can be displayed again using the <code>ticker!show</code> command.</li>
<li><code>ticker!clear</code>:  Clears all strings from the scrolling ticker. Note that this command only goes into effect once the current string completes scrolling (even if the ticker is hidden).</li>
<li><code>ticker!solid</code>: Specifies a black background for the Ticker zone (this is the default setting).</li>
<li><code>ticker!transparent</code>: Specifies a transparent background for the Ticker zone.</li>
