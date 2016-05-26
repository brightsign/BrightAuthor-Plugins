<p>This plugin allows you to perform  device setup by publishing a presentation to that device. Normally, you can only perform device setup by physically inserting a storage device into a player; for Local File Networking and Simple File Networking players, this means that you have to be next to the device to change device settings (some, but not all, BSN player settings can be changed via the <strong>Manage > Status</strong> tab in BrightAuthor). With this plugin, you can remotely publish the device setup files, and thus edit device settings remotely.</p>

###Creating the Device Setup Package
First, you’ll need to create a new set of device configuration files:
<ol>
<li>Go to <strong>Tools > Setup BrightSign Unit</strong>.</li> 
<li>Configure the new device settings as desired.</li> 
<li>Click <strong>Create Setup Files</strong>.</li> 
<li>Save the setup files to a folder on your PC.</li> 
<li>Place the setup files into a <em>.zip</em> folder. Name the <em>.zip</em> folder “autorun.zip”.</li>
</ol>
<p><strong>Important</strong>: Make sure the setup files and folders (<em>autoplugins.brs</em>, <em>birghtsign-dumps</em>, etc.) are located in the root directory of the <em>autorun.zip</em> folder, not a subdirectory of the zip folder. That is, if you open the .zip folder from Windows explorer, you shouldn’t have to click through any other folders to see the setup files and folders.</p>
<p><strong>Note</strong>: Because some folders are empty, they may disappear when you place them in the .zip folder. The plugin will recreate the necessary folders when performing device setup on the player.</p> 

###Adding the Device Setup Package and Plugin to a Presentation
Now, you’ll need to add the .zip file and plugin to a presentation for publishing:
<ol>
<li>Open a presentation to publish to the player(s). This can be a new presentation, or the same presentation that is currently running on the player(s).</li>
<li>Navigate to <strong>File > Presentation Properties > Autorun</strong>.</li>
<li>Click <strong>Add Script Plugin</strong>.</li>
<li>Locate and select the <em>setup_plugin.brs</em> file.</li>
<li>Specify the plugin <strong>Name</strong> as “setup”.</li>
<li>In the <strong>Presentation Properties</strong> window, navigate from the <strong>Autorun</strong> tab to the <strong>Files</strong> tab.</li>
<li>Click <strong>Add File</strong>.</li>
<li>Locate and select the <em>autorun.zip</em> file.</li>
<li>Publish the presentation as you would normally.</li>
</ol>
<p>This plugin works with all publishing methods. When the player receives the presentation, it will perform device setup using the generated setup files, reboot, and begin playing the presentation that was publihsed to it.</p>
