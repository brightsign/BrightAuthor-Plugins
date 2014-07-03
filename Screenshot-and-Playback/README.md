Overview
---------
<p>This plugin has two features: First, it takes a screeenshot of the player display output once every ten seconds (each screenshot image file overwrites the previous image file); second, it can display image or video files using a Plugin Message command or UDP command as a trigger.</p>

Customizing the Screenshot Function
-----------------------------------
<ul>
<li><strong>Resolution</strong>: The default resolution of each screeshot is 1280 by 720. This can be changed by editing the <code>width</code> and <code>height</code> parameters on line 380 of the plugin script.</li>
<li><strong>Filename/Filepath</strong>: The file is saved in the root folder of the SD card as "screen.jpg". A new fileneame and filepath can be specified by changing the <code>filename</code> parameter.</li>
<li><strong>File Type</strong>: The default image file type is JPEG. It can be changed to "BMP" by editing the  <code>filetype</code>.</li>
</ul>

Triggering Content Playback
---------------------------
<p>The playback portion of the plugin can accept three commands:</p> 
<ul>
<li><code>play!filename</code>: Plays the image or video file specified after the "!".</li>
<li><code>play!transition!transition_number</code>: Specifies the transition type between images that are played using this plugin. Use an integer to specify the desired transition:</li>
<ul>
<li>0 - No transition: immediate blit</li>
<li>1 to 4 - Wipes from top, bottom, left, or right.</li>
<li>5 to 8 - Explodes from centre, top left, top right, bottom left, or bottom right.</li>
<li>10 to 11 - Uses vertical and horizontal venetian blinds.</li>
<li>12 to 13 - Combs vertical and horizontal.</li>
<li>14 - Fades out to background color, then back in.</li>
<li>15 - Fades between current image and new image.</li>
<li>16 to 19 - Slides from top, bottom, left or right.</li>
<li>20 to 23 – Slides entire screen from top, bottom, left, or right.</li>
<li>24 to 25 – Scales old image in, then the new one out again (this works as a pseudo rotation around a vertical or horizontal axis, respectively).</li>
<li>26 to 29 – Expands a new image onto the screen from right, left, bottom, or top.</li>
</ul>
