Overview
--------
<p>This plugin allows you to show or hide a Ticker or Clock zone using Plugin Message or UDP command. When adding this plugin to your BrightAuthor presentation in <strong>File > Presentation Properties > Autorun</strong>, make sure to specify the plugin <strong>Name</strong> as "custom".</p>

Sending Commands to the Plugin
-----------------------------
<p>If your presentation has a single Ticker zone and/or Clock zone, you can send the following Plugin Message or UDP commands to the plugin. Note that attempting to use these commands with multiple Ticker zones or Clock zones will cause unpredictable results.</p>
<ul>
<li><code>clock!hide</code>: Causes the Clock zone to disappear from the screen.</li>
<li><code>clock!show</code>: Causes the Clock zone to reappear on the screen.</li>
<li><code>ticker!hide</code>: Causes the Ticker zone to disappear from the screen.</li>
<li><code>ticker!show</code>: Causes the Ticker zone to reappear on the screen.</li>
</ul>

<p>If your presentation contains multiple Ticker zones and/or Clock zones, you can send the following Plugin Message or UDP commands to the plugin:</p>
<ul>
<li><code>clock!hide![zone_name]</code>: Causes the Clock zone with the specified <code>zone_name</code> to disappear from the screen.</li>
<li><code>clock!show![zone_name]</code>: Causes the Clock zone with the specified <code>zone_name</code> to reappear on the screen.</li>
<li><code>ticker!hide![zone_name]</code>: Causes the Ticker zone with the specified <code>zone_name</code> to disappear from the screen.</li>
<li><code>ticker!show![zone_name]</code>: Causes the Ticker zone with the specified <code>zone_name</code> to reappear on the screen.</li>
