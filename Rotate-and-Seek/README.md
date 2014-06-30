Overview
---------
<p>This plugin allows you to rotate a video or seek to a certain position in a video. These actions can be triggered using Plugin Message commands or UDP commands on port 555.</p>

Rotate
------
<p>To trigger a rotation, the Plugin Message or UDP command must be formatted as follows:</p>
<code>rotate![zone_name]![rotate_type]</code>

<p><strong>zone_name</strong>: The name of the video zone you wish to rotate.</p>
<p><strong>rotate_type</strong>: The type of video rotation to be performed. The following parameters can be used:
<ul>
<li>rot90: 90 degree clockwise rotation</li>
<li>rot180: 180 degree rotation</li>
<li>rot270: 270 degree clockwise rotation</li>
<li>mirror: Horizontal mirror transformation</li>
<li>mirror_rot90: Mirrored 90 degree clockwise rotation</li>
<li>mirror_rot180: Mirrored 180 degree clockwise rotation</li>
<li>mirror_rot270: Mirrored 270 degree clockwise rotation</li>
</li>
