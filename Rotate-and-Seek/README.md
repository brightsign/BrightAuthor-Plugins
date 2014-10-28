Overview
---------
<p>This plugin allows you to rotate a video or seek to a certain position in a video. It also allows you to create a Ticker zone with smooth scrolling text. All these actions can be triggered using Plugin Message commands or UDP commands on port 555.</p>

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

Scrolling Ticker
---------------
<p>Use the following Plugin Message or UDP command to initialize a Ticker zone with scrolling text:</p>
<code>ticker!scroll!x!y!w!h</code> 
<p>The <code>x</code> and <code>y</code> parameters specify the coordinates of the top left corner of the zone, and <code>w</code> and <code>h</code> parameters represent the width and height of the zone. Note that the Ticker zone is not created using the <strong>Edit > Layout</strong> tab in BrightAuthor.</p>

Once the Ticker zone is initialized, it can be shown on screen using the <code>ticker!show</code> command. You can also use the following commands to manipulate the zone after it is initialized:
<ul>
<li><code>ticker!add!text</code>: Adds the <code>text</code> to the list of strings displayed by the scrolling ticker.
<li><code>ticker!message.txt</code>: Scrolls the contents of the <em>message.txt</em> file that is included with the presentation (miscellaneous files can be added to a presentation using the <strong>File > Presentation Properties > Files</strong> tab). Note that this command clears all other strings that have been added to the scrolling ticker.
<li><code>ticker!hide</code>: Hides the ticker from view. It can be displayed again using the <code>ticker!show</code> command.</li>
<li><code>ticker!clear</code>:  Clears all strings from the scrolling ticker. Note that this command only goes into effect once the current string completes scrolling (even if the ticker is hidden).</li>
<li><code>ticker!solid</code>: Specifies a black background for the Ticker zone (this is the default display).</li>
<li><code>ticker!transparent</code>: Specifies a transparent background for the Ticker zone.</li>
