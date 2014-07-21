Overview
---------
<p>This plugin allows you to return to the previous presentation when switching among presentations. Normally, when switching among a group of three or more presentations that are linked together with Switch Presentation command, there is no way to return to the previous presentation without using a complicated set of conditional expressions and User Variables. With this plugin, you can have the current presentation return to whatever presentation switched to it previously.</p>

Adding the Plugin to Presentations
----------------------------------
<p>To add the plugin to a presentation, navigate to <strong>File > Presentation Properties > Autorun</strong> and click <strong>Add Script Plugin</strong>. Specify the plugin <strong>Name</strong> as "switch". Repeat this process for <em>every</em> presentation in the group (not just the presentations that will be using the plugin).</p>

Adding Additional Switch Presentations
-----------------------------------
<p>Navigate to <strong>File > Presentation Properties > Switch Presentations</strong> and use the <strong>Add Presentation</strong> button to add all other presentations in the group. Repeat this process for every presentation in the group.</p>

Using the Plugin
----------------
<p>To switch back to the previous presentation, instead of adding a Switch Presentation command to an event or state, add a Plugin Message command, select the <strong>switch</strong> plugin, and use "restore" as the message body.</p>

<p>Before switching to a presentation that will use the "restore" command, the first presentation will also need to send a Plugin Message to specify which presentation should be restored: Add a Plugin Message to an event or state that will occur before the switch; select the <strong>switch</strong> plugin and use "save![project_name]" as the message body, where "[project_name]" is the name the presentation that should be returned to once the "restore" Plugin Message is called.</p>

<p>The workflow of the plugin can be described as follows:</p>
<ol>
<li>The first presentation begins.</li>
<li>A Plugin Message command is sent with "save![project_name]" as the message body.</li>
<li>A Switch Presentation command is used to transition to the next presentation.</li>
<li>The next presentation begins. At some point, a Plugin Message command is sent with "restore" as the message body. This switches the presentation to whatever "[project_name]" was specified in Step 2.</li>
</ol>

<p><strong>Note</strong>: The Restore Presentation plugin also works with UDP commands. When sending UDP commands to trigger the plugin, format the message bodies as "switch!save![project_name]" and "switch!restore", respectively.</p>
