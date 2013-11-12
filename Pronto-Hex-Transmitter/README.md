IR Command Transmitter (Pronto Hex)
-----------------------------------

Overview
========
<p>
Current versions of BrightAuthor only support sending and receiving IR commands in NEC format. However, as of firmware version 4.7.96, BrightSign system software allows sending and receiving using the <a href="Pronto Hex Code">http://www.remotecentral.com/features/irdisp2.htm</a> (PHC) protocol. You can use the <em>sendir.brs</em> plugin to send PHC formatted IR commands from a BrightAuthor presentation.
</p>
<p>
This plugin sends PHC commands when prompted by a <b>Send Plugin Message</b> command or a <b>UDP</b> command. <b>Send Plugin Message</b> commands are triggered by conditions within the interactive presentation (like a timer or media transition); <b>UDP</b> commands are sent to the player from another client on the local network.
</p>
<p>
This ReadMe file explains how to add PHC codes to the plugin for different products and commands. It also details how to create commands that will trigger the plugin while the presentation is running.
</p>
