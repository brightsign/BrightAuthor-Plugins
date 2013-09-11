Overview
-----------
<p>This plug-in allows you to save system logs to the local storage of the player. These system logs have more detailed debugging information than the standard logs that are enabled during player setup. If the Diagnostic Web Server is enabled on the player, you can retrieve these logs remotely, without having to remove the SD card or reboot the player.</p>
<p>The plug-in appends the date to the front of the “kernel_log.txt” file name in mmddyyy format. This means that a new file is saved each day. During any one day, the same log file will be overwritten however many times BrightAuthor executes the parser (e.g. “Every 5 minutes”, “Every hour”).</p>
<p>We do not recommend including this plug-in as part of your permanent set up: The system log files will eventually fill up all the free space on the local storage, and this process can occur at an unpredictable rate. This plug-in is intended for laboratory and test setups where additional information about the player environment may be useful.</p>
Adding the Parser
------------------------
<p>You will need to add the plug-in script to your presentation as a Data Feed parser.</p>
<ol>
<li>Navigate to File > Presentation properties.</li> 
<li>Select the Data Feeds tab and click the Add Data Feed button.</li>
<li>Enter a Feed name for the Data Feed.</li>
<li>Enter the following URL in the Feed Specification field: file:///autoplugins.brs</li>
Note: Since we’re only interested in adding a plug-in script to the presentation, having a working Data Feed is not necessary. Therefore, the goal here is simply to have URL that will always be valid, rather than having an actual Data <li>Feed to use or display in the presentation.</li>
<li>Choose an Update Interval. This will determine how often the system log file will be saved to the local storage.</li>
<li>Use the Browse button to locate and select the plug-in script.</li>
<li>Enter “klog” in the Parser Function Name field.</li>
<li>Click OK.</li>
</ol>
