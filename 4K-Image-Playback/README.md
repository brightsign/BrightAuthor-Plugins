Overview
----------
<p>This plugin allows you to display 4K images using a 4K242, 4K1042, or 4K1142 player. The images are played alphabetically from a folder manually placed on the SD card--as a result, this plugin can currently be used with the Standalone publishing method only.</p>

<p><strong>Note</strong>:<em>This plugin uses the 4K video decoder to display 4K images; this means that you cannot display a 4K image and a 4K video at the same time. You can, however, display a 4K image and an HD video simultaneously if desired.</em></p>

Adding the Plugin to your Presentation
-------------
<p>To add this plugin to your BrightAuthor presentation, navigate to <strong>File > Presentation Properties > Autorun</strong> and click <strong>Add Script Plugin</strong>. Locate and select the 4K Image Playback plugin. Specify the plugin <strong>Name</strong> as "PlayImagesFromFolder".</p>

Creating a 4K Image Playlist
----------------------------
<p>To utilize this plugin, your presentation must have a Video Only zone or Video or Images zone that occupies the entire screen--this zone will still display 1920x1080 as its width and height dimensions in the <strong>Edit > Layout</strong> tab. You will also need to use an interactive playlist with this zone.</p>
<ol>
	<li>Create an Event Handler state for the 4K images you wish to display. This Event Handler state can be positioned anywhere in the playlist, but it <em>cannot</em> be the Home State of the playlist. If you want to play 4K images as an initial step, you can add a very short Timeout event (.1 seconds) between the Home State and the Event Handler state.</li>
	<li>Add an event of any type (Timeout, Media End, UDP, etc.) that will transition to the Event Handler state.</li>
	<li>Open the event and click the <strong>Advanced</strong> tab.</li>
	<li>Click <strong>Add Command</strong> and select the <strong>Send - Send Plugin Message</strong> command.</li>
	<li>Select the "PlayImagesFromFolder" plugin and enter the message text as "FolderPlay". This message will trigger your playlist of 4K images to begin playing while the Event Handler state is running.</li>
	<li>Add a Plugin Message event to transition away from the Event Handler state.</li>
	<li>In the <strong>Plugin message</strong> field, enter "BAPlay". Once your playlist of 4K images finishes playing, the presentation will receive the "BAPlay" message from the playlist and transition away from the event handler state.</li>
</ol>

<p>If you want the 4K image playlist to play in a continuous loop, add the <strong>Send - Send Plugin Message</strong> command from Steps 4-5 to the Plugin Message event attached to the Event Handler state and set the Plugin Message event to <strong>Remain on current state</strong>.</p>

Configuring 4K Image Timeout
----------------------------
<p>You will need to create a User Variable to specify the timeout interval for the 4K images.</p>
<ol>
	<li>Navigate to <strong>File > Presentation Properties > Variables</strong>.</li>
	<li>Click <strong>Add Variable</strong> and specify the variable <strong>Name</strong> as "ImageTimeOUTinSeconds".</li>
	<li>Enter a <strong>Default Value</strong>: This value corresponds to how many seconds each 4K image will be displayed on screen.</li>
</ol>

Adding the 4K Images to the Presentation
----------------------------------------
<p>You will add your 4K images after creating and publishing the presentation.</p>
<ol>
	<li>Once you've finished editing the presentation, publish it to an SD card using the Standalone publishing method.</li>
	<li>Use your operating system to navigate to the root directory of the SD card ("SD:/").</li>
	<li>Add a new folder to the root directory and name it "4KImages".</li>
	<li>Add your 4K images to the "4KImages" folder. These images will be displayed alphabetically whenever the presentation transitions to the Event Handler state and sends the "FolderPlay" command.</li>
</ol>
	

