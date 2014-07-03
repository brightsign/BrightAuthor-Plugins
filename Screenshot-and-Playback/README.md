Overview
---------
<p>This plugin has two features: First, it takes a screeenshot of the player display output once every ten seconds (each screenshot image file overwrites the previous image file); second, it can display image or video files using a Plugin Message command or UDP command as a trigger.</p>

Customizing the Screentshot Function
-----------------------------------
<ul>
<li><strong>Resolution</strong>: The default resolution of each screeshot is 1280 by 720. This can be changed by editing the <code>width</code> and <code>height</code> parameters on line 380 of the plugin script.</li>
<li><strong>Filename/Filepath</strong>: The file is saved in the root folder of the SD card as "screen.jpg". A new fileneame and filepath can be specified by changing the <code>filename</code> parameter.</li>
<li><strong>File Type</strong>: The default image file type is JPEG. It can be changed to "BMP" by editing the  <code>filetype</code></li>
