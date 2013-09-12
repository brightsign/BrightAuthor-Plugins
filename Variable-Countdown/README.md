Overview
--------------
<p>This BrightAuthor plug-in allows you to create User Variables that count down from a customizable number at customizable intervals of both time and amount. This is useful if you would like to place timers within Live Text: For example, in between informational videos, you could display a Live Text zone announcing that “The next video will play in [variable value] minutes,” with the variable value diminishing by 1 every sixty seconds.</p>
<p>The interval of time represented by the variable can be determined when the presentation is published or determined dynamically with a serial event, UDP event, or Networked User Variable.</p>
<strong>Note</strong>: <em>To learn more about Live Text states, User Variables, UDP events, and other advanced features, please see the <a href="http://support.brightsign.biz/entries/314526-brightsign-user-guides-troubleshooting">BrightAuthor User Guide</a>.</em>

Creating the User Variable
----------------------------------
<p>First, you will need to create a User Variable that acts as a countdown timer: </p>
<ol>
<li>Go to <strong>File > Presentation Properties</strong>.</li>
<li>Navigate to the <strong>Variables</strong> tab and click the <strong>Add Variable</strong> button.</li>
<li>Enter “countdown” in the <strong>Name</strong> field. You can choose another name for the User Variable if desired, but then you will need to modify the parser by changing instances of “countdown” in the plug-in script as well.</li>
<li>Enter a <strong>Default Value</strong> for the User Variable. This determines the value at which the countdown begins.</li>
</ol>

Adding the Parser
-----------------------
<p>Now you will need to add the plug-in script that will determine the countdown time and interval.</p>
<ol>
<li>While in the <strong>Presentation properties</strong>  window, navigate to the <strong>Data Feeds</strong> tab and click the <strong>Add Data Feed</strong> button.</li>
<li>Enter a <strong>Feed name</strong> for the Data Feed.</li>
<li>Enter the following URL in the <strong>Feed Specification</strong> field: file:///autoplugins.brs</li>
<strong>Note</strong>: <em>Since we’re only interested in adding a plug-in script to the presentation, having a working Data Feed is not necessary. Therefore, the goal here is simply to have URL that will always be valid, rather than having an actual Data Feed to use or display in the presentation.<em>
<li>Choose an <strong>Update Interval</strong>. This will determine how often the variable counts down.</li>
<li>Use the <strong>Browse</strong> button to locate and select the plug-in script.</li>
<li>Enter “countdown” in the <strong>Parser Function Name</strong> field.</li>
<li>Click OK.</li>
</ol>
<p>You’ve now created a User Variable that starts with a specified value, and then counts down from that value at a specified interval (every 30 seconds, every minute, every 5 minutes, etc.). </p>

Creating a Live Text State
----------------------------
<p>Now you can create a presentation that displays the countdown User Variable. You can display User Variables as text on screen using the Live Text state, which is available in Images zones and Video or Images zones.</p>
<ol>
<li>Click the <strong>interactive</strong> option to the right of the playlist to make the presentation interactive.</li>
<li>Select the <strong>other</strong> tab in the <strong>Media Library</strong> section.</li>
<li>Drag and drop the <strong>Live Text</strong> icon onto the playlist area.</li>
<li>Enter a <strong>State name</strong> and specify a <strong>Background Image</strong> (if desired).</li>
<li>Change the type of the text box to <strong>User Variable</strong> and select “countdown”.</li>
<li>(Optional) Use the <strong>Add Item</strong> button to create additional text boxes for fixed text, user variables, data feeds, etc.</li>
</ol>

Customizing the Plug-In
-------------------------------
<p>By default, the parser counts down 1 for every interval, but you can customize this too by editing the parser file.</p>
<ol>
<li>Open the “var_countdown.brs” file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Locate the line that states <code>if currentvalue > 0 then currentvalue = currentvalue-1</code>. This is the argument that determines what happens each time the update interval occurs for the parser script.</li>
<li>Modify the equation after <code>currentvalue =</code> to create the desired behavior. For example, you can have the User Variable count down by five at each interval (<code>currentvalue = currentvalue-5</code>), or you can make the User Variable count up instead of down: (<code>current value = currentvalue+1</code>).</li>
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
