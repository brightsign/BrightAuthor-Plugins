Overivew
---------
<p>Use this plugin to send a UDP string that is hexidecimal formatted and contains a carriage return. When adding this plugin to your presentation in <strong>File > Presentation Properties > Autorun</strong>, make sure to to specify the <strong>Name</strong> as "udphex". </p>

<p>To send hexidecimal formatted UDP commands with this plugin, use the Plugin Message command to send the following message to the plugin:</p>

<code>Udp![hex_command]</code>

<p>Note that the [hex_command] should not include any text used to mark it as hexidecimal formatted (such as a leading "x", "h", or "0"). The carriage return will be added to the end of the message when it is sent over UDP</p>.
