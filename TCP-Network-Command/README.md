Overview
-------
<p>These plugins allow you to send commands over the local network using a TCP connection.</p>

Customizing the PJLinkOn Plugin
-------------------------------
<p> By default, this plugin sends a hexidecimal-formatted TCP message to an IP address, which is specified in the body of the Plugin Message command that triggers the plugin.</p>
<p>The following list outlines different aspects of the plugin script that can be customized:</p>
<ul>
<li><strong>Plugin Name</strong>: If you'd like to use a different plugin name than "PJLinkOn", you will need to change the value associated with the <code>"PluginName"</code> key on line 33 of the plugin script. This new value must be identical to the <strong>Name</strong> given to the script plugin in the <strong>File > Presentation Properties > Autorun</strong> tab in BrightAuthor.</li>
<li><strong>Message Body</strong>: To change the body of the hexidecimal-formatted TCP message, edit the <code>projector_message$</code> value on line 28 of the plugin script.</li>
<li><strong>Destination Port</strong>: To change the destination port of device receiveing the TCP message, edit the <code>projector_port</code> value on line 27 of the plugin script.</li>
</ul>

SendTCPBytes Plugin
-------------------
<p>This plugin sends a hexidecimal-formatted TCP message to a custom IP address and port.</p>
<p>Message, IP address, and port are all supplied via plugin message. The plugin message is expected to be in JSON format.</p>

### For example:
```json
{"ip":"10.0.0.42", "port":"4661", "message": "0614000400341100005D"}
```
(will turn on some ViewSonic projectors - expected message content may vary)

SendTCPString Plugin
-------------------
<p>This plugin sends a ASCII-formatted TCP message to a custom IP address and port.</p>
<p>Message, IP address, and port are all supplied via plugin message. The plugin message is expected to be in JSON format.</p>

### For example:
```json
{"ip":"10.0.0.42", "port":"2123", "message": "hello world"}
```
(sends the message "hello world" to a device:service at 10.0.0.42:2123)
