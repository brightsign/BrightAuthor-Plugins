Overview
----------
<p>This plugin allows you to set Chroma (cb/cr) or Luma keying values for a <strong>Video Only</strong> or <strong>Video or Images</strong> zone. Video pixels will appear transparent if their values fall within the specified YCbCr range, allowing background video or graphics to show through. The YCbCr range is set from BrightAuthor using a Plugin Message command. </p>

<p><strong>Note</strong>: <em>Chroma/Luma keying is supported on the following models: 4Kx42, XDx32, and XDx30 (running firmware version 4.8.88 or later).</p>

Adding the Plugin to your Presentation
-------------
<p>To add this plugin to your BrightAuthor presentation, navigate to <strong>File > Presentation Properties > Autorun</strong> and click <strong>Add Script Plugin</strong>. Make sure to specify the plugin <strong>Name</strong> as "chromaLuma".</p>

Configuring Chroma/Luma Values
--------
<p>To set the Chroma/Luma values for a zone, use a Plugin Message command formatted as follows:</p>
<code>chromaLuma![zone\_name]![luma\_value]![cr\_value]![cb\_value]</code>
<p>
<ul>
	<li><code>[zone_name]</code>: The name of the zone to which the keying values will be applied. The BrightAuthor zone name must be in all lowercase for it to match the plugin message. You can edit the zone name can in the <strong>Edit > Layout</strong> tab.</li>
	<li><code>[luma_value]</code>: The Luma value to be applied to the zone.</li>
	<li><code>[cr_value]</code>: The cr Chroma value to be applied to the zone.</li>
	<li><code>[cb_value]</code>: The cb Chroma value to be applied to the zone.</li>
</ul>
</p>
<p>The luma, cr, and cb values work by applying a mask to each pixel in the video window. If a pixel value falls within the specified range of chroma and luma key values, the pixel will appear transparent, allowing video and graphics behind it to show through.</p>

<p>The luma, cr, and cb values are specified as follows: <code>[8 bits of mask][8 bits of high-end range][8 bits of low-end range]</code>. For example, the following plugin message will mask all black (or near-black) luma values for videos in the zone named "top_zone", allowing for video or graphics in a zone behind it to show through (the masking values for Cr/Cb are left undefined using the <code>000000</code> value for each):</p>
<p><code>chromaLuma!top_zone!FF2000!000000!000000</code></p>

<p>The luma values correspond to the following:</p>
<ul>
	<li><code>FF</code>: This value specifies the mask for the pixel value. This value is usually set to 0xFF (255).</li>
	<li><code>20</code>: This value specifies the high-end of the luma range to be masked.</li>
	<li><code>00</code>: This value specifies the low-end of the luma range to be masked.</li>
</ul>

<p>The following Plugin Message will also render black pixels transparent:</p>
<code>chromaLuma!top_zone!FF2000!FF8778!FF8778</code>

<p>Conversely, this Plugin Message can be used to render white pixels transparent:</p>
<code>chromaLuma!top_zone!FFEBB4!FFF064!FFF064</code>

Using a Backdrop Zone in BrightAuthor
--------------------------------------
<p>Transparent pixels display the content of the zone directly beneath the Chroma/Luma-keyed zone. The backdrop can be either video (Video Only, Video or Images) or graphics (Images, Ticker, Clock, etc.):</p>
<ul>
	<li><strong>Video</strong>: Ensure the video backdrop zone is located behind the Chroma/Luma-keyed zone; navigate to the <strong>Edit > Layout</strong> tab and set the <strong>Video Position Z</strong> to <strong>Back</strong>.</li>
	<li><strong>Graphics</strong>: Ensure the graphics backdrop zone is located behind the Chroma/Luma-keyed zone; navigate to the <strong> Edit > Layout</strong> tab and set the <strong>Graphics plane z position</strong> to <strong>Back</strong> or <strong>Between</strong>. Note that, if you're using multiple graphics zones as a backdrop, the ordering of graphics zones in relation to each other can be unpredictable.</li>
</ul>
