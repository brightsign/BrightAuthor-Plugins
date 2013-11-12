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

##Editing the Plugin
<p>
By default, the plugin comes with “tvon”, “tvoff”, “prjon”, and “prjoff” commands already specified. However, the codes sent by the plugin will probably not work with your specific product. Therefore, you will need to edit the <em>sendir.brs</em> plugin file to make the PHC commands compatible.
</p>
<ol>
<li>Visit this site and locate the brand and model of your product. You will be provided with a list of compatible PHC codes for the device.</li>
<li>Open the sendir.brs file with a text editor program (Notepad, TextMate, etc.).</li>
<li>Locate the s.tvoff, s.tvon, s.prjoff, and s.prjon values within the newSendIR function.</li>
<li>For each command you wish to use, replace the PHC command string in the script with the PHC command string found on the website in Step 1.</li>
<li>Change the last set of four hex digits in each command to all zeros.</li>
</ol>
<b>Example</b>: <em>Many Panasonic models use commands that end with “0ac2”. When these commands are added to the plugin, those ending digits need to be changed to “0000” for the command to work.</em>
<p>
Most televisions accept a large number of IR commands beyond “off” and “on”. You can add additional commands to the list using these steps:
</p>
<ol>
<li>Add a new command to the list in the form of “s.command_name =”. </li>
</ol>
<b>Example</b>: <em>You could create a command for muting the television by adding a new line that states “s.mute =”.</em> 
<ol>
<li>Copy the Pronto Hex Code for the command from the site linked above.</li>
<li>Paste the code after the equals sign, making sure to change the last four digits to zeros as outlined above.</li>
</ol>
