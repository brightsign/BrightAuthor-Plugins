Overview
--------------
<p>This BrightAuthor plugin allows you to create User Variables that count down from a customizable number at customizable intervals of both time and amount. This is useful if you would like to place timers within Live Text: For example, in between informational videos, you could display a Live Text zone announcing that “The next video will play in [variable value] minutes,” with the variable value diminishing by 1 every sixty seconds.</p>
<p>The interval of time represented by the variable can be determined when the presentation is published or determined dynamically with a serial event, UDP event, or Networked User Variable.</p>
<strong>Note</strong>: <em>This plugin has been updated: It is now added to the presentation using the <strong>File > Presentation Properties > Autorun</strong> tab.</em>

Creating the User Variable
----------------------------------
<p>First, you will need to create a User Variable that acts as a countdown timer: </p>
<ol>
<li>Go to <strong>File > Presentation Properties</strong>.</li>
<li>Navigate to the <strong>Variables</strong> tab and click the <strong>Add Variable</strong> button.</li>
<li>Enter a desired <strong>Name</strong>  for the countdown variable. </li>
<li>Enter a <strong>Default Value</strong> for the User Variable. This determines the value at which the countdown begins.</li>
</ol>

Creating a Live Text State
----------------------------
<p>Now you can create a presentation that displays the countdown User Variable. You can display User Variables as text on screen using the Live Text state, which is available in Images zones and Video or Images zones.</p>
<ol>
<li>Click the <strong>interactive</strong> option to the right of the playlist to make the presentation interactive.</li>
<li>Select the <strong>other</strong> tab in the <strong>Media Library</strong> section.</li>
<li>Drag and drop the <strong>Live Text</strong> icon onto the playlist area.</li>
<li>Enter a <strong>State name</strong> and specify a <strong>Background Image</strong> (if desired).</li>
<li>Change the type of the text box to <strong>User Variable</strong> and select the user variable you created in the previous section.</li>
</ol>
Creating a Countdown Process
-----------------------------------------
<p>The User Variable is counted down once each time a <code>Countdown![variable_name]</code> Plugin Message or UDP command is sent to the plugin. This means that you will need to create a background process that sends messages to the plugin at regular intervals. The following steps show one of many ways to do this:</p>
<ol>
<li>Create an Audio Only zone in the <strong>Edit > Layout</strong> section. Note that it does not matter what kind of zone you use, as long as it's not visible to the viewer.</li>
<li>Add an <strong>Event Handler</strong> state to the new zone.</li>
<li>Add a <strong>Timeout</strong> event to the <strong>Event Handler</strong> state. </li>
<li>Set the event to <strong>Remain on current state</strong> and use the <strong>Specify timeout</strong> field to determine how often the timer should count down (i.e. once every second, once every 60 seconds).</li>
<li>Navigate to the <strong>Advanced</strong> tab and select <strong>Add Command</strong>. Select <strong>Send > Send Plugin Message</strong>.</li>
<li>Select the <em>var_countdown.brs</em> plugin. In the field to the right, enter <code>Countdown![variable_name]</code>, where the variable name specifies the variable you created earlier.</li>
</ol>
<p>Note that, once a countdown takes place, the variable value will not reset to its default value—even if the player is rebooted. If you need the countdown variable to reset to its default value at some point in the presentation, you can add a <strong>Reset Variable</strong> or <strong>Set Variable</strong> command to some point in the presentation. You can also have variables reset after reboot by checking the <strong>Reset variables to their default value on presentation start</strong> box in <strong>File > Presentation Properties > Variables</strong> tab.</p>

Customizing the Plugin
-------------------------------
<p>By default, the plugin counts down by 1 each time it is called, but you can customize this too by editing the plugin file.</p>
<ol>
<li>Open the “var_countdown.brs” file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Locate the line that states <code>if tempval > 0 then tempval = tempval-1</code>. This is the argument that determines what happens each time the update interval occurs for the plugin script.</li>
<li>Modify the equation after <code>tempval =</code> to create the desired behavior. For example, you can have the User Variable count down by five at each interval (<code>tempval = tempval-5</code>), or you can make the User Variable count up instead of down: (<code>if tempval >= 0 then current value = tempval+1</code>).</li>
<li>Save the modified “var_countdown.brs” when you are finished making edits.</li>
</ol>

Setting the Timer Value
-----------------------------------
<p>If you want to dynamically set the beginning value of the countdown timer, attach a Set Variable command to your desired input event (UDP, keyboard, GPIO, etc.):</p> 
<ol>
<li>Navigate to the <strong>Advanced</strong> tab in the event.</li>
<li>Click the <strong>Add Command</strong> button.</li>
<li>Under <strong>Commands,</strong>, choose <strong>Other</strong>.</li>
<li>Under <strong>Command Parameters</strong>, choose <strong>Set Variable</strong>.</li>
<li>Enter the name of the countdown User Variable in the <strong>Variable</strong> field. Enter the beginning value of the countdown User Variable in the <strong>Value</strong> field.</li>
<li>Click <strong>OK</strong> when finished.</li>
</ol>
