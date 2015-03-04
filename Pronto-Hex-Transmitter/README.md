##Pronto Hex Transmitter Instructions

###Overview
<p>
Current versions of BrightAuthor only support sending and receiving IR commands in NEC format. However, as of firmware version 4.7.96, BrightSign system software allows sending and receiving using the <a href="http://www.remotecentral.com/features/irdisp2.htm">Pronto Hex Code</a> (PHC) protocol. You can use the <em>sendir.brs</em> plugin to send PHC formatted IR commands from a BrightAuthor presentation.
</p>
<p>
This plugin sends PHC commands when prompted by a <b>Send Plugin Message</b> command or a <b>UDP</b> command. <b>Send Plugin Message</b> commands are triggered by conditions within the interactive presentation (like a timer or media transition); <b>UDP</b> commands are sent to the player from another client on the local network.
</p>
<p>
This ReadMe file explains how to add PHC codes to the plugin for different products and commands. It also details how to create commands that will trigger the plugin while the presentation is running.
</p>

###Editing the Plugin
By default, the plugin comes with “tvon”, “tvoff”, “prjon”, and “prjoff” commands already specified. However, the codes sent by the plugin will probably not work with your specific product. Therefore, you will need to edit the <em>sendir.brs</em> plugin file to make the PHC commands compatible.
<ol>
<li>Visit <a href="http://www.remotecentral.com/cgi-bin/codes/">this site</a> and locate the brand and model of your product. You will be provided with a list of compatible PHC codes for the device.</li>
<li>Open the sendir.brs file with a text editor program (Notepad, TextMate, etc.).</li>
<li>Locate the <code>&lt;s.tvoff&gt;</code>, <code>&lt;s.tvon&gt;</code>, <code>&lt;s.prjoff&gt;</code>, and <code>&lt;s.prjon&gt;</code> values within the newSendIR function.</li>
<li>For each command you wish to use, replace the PHC command string in the script with the PHC command string found on the website in Step 1.</li>
<li>Change the last set of four hex digits in each command to all zeros.</li>
<b>Example</b>: <em>Many Panasonic models use commands that end with “0ac2”. When these commands are added to the plugin, those ending digits need to be changed to “0000” for the command to work.</em>
</ol>
Most televisions accept a large number of IR commands beyond “off” and “on”. You can add additional commands to the list using these steps:
<ol>
<li>Add a new command to the list in the form of <code>&lt;“s.command_name =”&gt;</code>. </li>
<b>Example</b>: <em>You could create a command for muting the television by adding a new line that states <code>&lt;“s.mute =”&gt;</code>.</em> 
<li>Copy the Pronto Hex Code for the command from the site linked above.</li>
<li>Paste the code after the equals sign, making sure to change the last four digits to zeros as outlined above.</li>
</ol>

###Adding the Plugin to the Presentation
After you edit and save the sendir.brs plugin, you will need to add it to your presentation:
<ol>
<li>Navigate to <b>File > Presentation Properties</b>.</li>
<li>Select the <b>Autorun</b> tab and click the <b>Add Script Plugin</b> button.</li>
<li>Click <b>Browse</b> to locate and select the <em>sendir.brs</em> file.</li>
<li>Enter the <b>Name</b> as “sendir”.</li>
</ol>

###Using Plugin Messages
If you wish to send a PHC IR command based on events in the interactive presentation, use a Send Plugin Message command. The Send Plugin Message command will trigger the corresponding PHC IR command in the plugin script.
<ol>
<li>Open an event, state, or media file within your interactive playlist. If you choose a state or media file, the <b>Send Plugin Message</b> command will be sent when the state or file begins.</li>
<li>Select the <b>Advanced</b> tab and click the <b>Add Command</b> button.</li>
<li>Select <b>Send</b> under <b>Commands</b>.</li>
<li>Select <b>Send Plugin Message</b> under <b>Command Parameters</b>.</li>
<li>Use the dropdown list to specify the “sendir” plugin that you added to the presentation.</li>
<li>Enter “tvon”, “tvoff”, “prjon”, or “prjoff” into the field for the command string. If you added other commands in the <b>Editing the Plugin</b> section above, you can also use those command strings here.</li>
<li>Click <b>OK</b> when finished.</li>
</ol>

###Using UDP Commands
<p>
To send PHC IR commands based on UDP input, you will need to set up another device to send UDP packets to the player. This could be a second networked BrightSign player, a tablet running the BrightSign App, or some other device capable of sending UDP packets over the local network. 
</p>
The plugin script accepts UDP commands in the following format: <em>sendir!command</em>
<ul>
<li>The plugin listens for any incoming UDP messages that begin with “sendir”</li>
<li>“!” separates the string that initializes the command from the string that specifies which IR command to send. For example, the UDP message for the TV on command would be formatted as “sendir!tvon”, and the UDP message for the example mute command would be “sendir!mute”.</li>
</ul>
