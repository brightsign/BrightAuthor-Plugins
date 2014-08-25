Overview
-----------
<p>This plugin allows you to save system logs to the local storage of the player. These system logs have more detailed debugging information than the standard logs that are enabled during player setup. If the Diagnostic Web Server is enabled on the player, you can retrieve these logs remotely, without having to remove the SD card or reboot the player.</p>
<p>The plugin appends the date to the front of the “kernel_log.txt” file name in mmddyyy format. This means that a new file is saved each day. During any one day, the same log file will be overwritten however many times BrightAuthor executes the parser (e.g. “Every 5 minutes”, “Every hour”).</p>
<p>We do not recommend including this plugin as part of your permanent set up: The system log files will eventually fill up all the free space on the local storage, and this process can occur at an unpredictable rate. This plugin is intended for laboratory and test setups where additional information about the player environment may be useful.</p>
Adding the Parser
------------------------
<p>You will need to add the plugin script to your presentation as a Data Feed parser.</p>
<ol>
<li>Navigate to <strong>File > Presentation properties</strong>.</li> 
<li>Select the <strong>Data Feeds</strong> tab and click the <strong>Add Data Feed</strong> button.</li>
<li>Enter a <strong>Feed name<strong> for the Data Feed.</li>
<li>Enter the following URL in the <strong>Feed Specification</strong> field: file:///autoplugins.brs</li>
<strong>Note</strong>: <em>Since we’re only interested in adding a plugin script to the presentation, having a working Data Feed is not necessary. Therefore, the goal here is simply to have URL that will always be valid, rather than having an actual Data Feed to use or display in the presentation.</em>
<li>Choose an <strong>Update Interval</strong>. This will determine how often the system log file will be saved to the local storage.</li>
<li>Use the <strong>Browse</strong> button to locate and select the plugin script.</li>
<li>Enter “klog” in the <strong>Parser Function Name</strong> field.</li>
<li>Click <strong>OK</strong>.</li>
</ol>
