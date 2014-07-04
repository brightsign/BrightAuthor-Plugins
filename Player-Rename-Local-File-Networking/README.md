Overview
---------
<p>This plugin allows you to change the name of a player using a User Variable, Plugin Message command or UDP command over the local network.</p>

Renaming a Player with a User Variable
------------------
<p>After adding the plugin to a presentation, you will also need to add a User Variable with the <strong>Name</strong> "lname" and a <strong>Default Value</strong> corresponding to the new player name. Once the presentation is published, the player will reboot and rename itself. Whenever the player reboots, it will determine if the new name is already in use or not.</p>

Renaming a Player with a UDP or Plugin Message Command
------------------------------------------------------
<p>Once the presentation is published, you can rename the player by sending a UDP or Plugin Message command with the following message body: <code>lfnrename![player_name]</code>. For example, to rename the player to "unit27", you can send a UDP message to the player with the body <code>lfnrename!unit27</code></p>.

<p><strong>Note</strong>: <em>The "lname" variable value will always overwrite the name specified in a UDP or Plugin Message command.</em></p>

<p>By default, the plugin will receive UDP commands on port 555. This can be changed by editing the <code>s.udpReceiverPort</code> value on line 25 of the plugin script.</p>
