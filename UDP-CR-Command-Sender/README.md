Overview
-------------
<p>Use this plugin to send UDP strings that contain a carriage return <cr> at the end. When adding this plugin to your presentation in <strong>File > Presentation Properties > Autorun </strong>, make sure to specify the plugin <strong>Name</strong> as "udpcr".</p>

<p>To send UDP commands with this plugin, use the Plugin Message command to send the following string to the plugin:</p>

<code>Udp![string]</code>

<p>The carriage return will be added to the end of the string when it is sent over UDP.</p>
