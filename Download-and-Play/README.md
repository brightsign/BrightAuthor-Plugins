README
--------
<p>This plugin allows you to download an image from a URL and display it using a Plugin Message command or UDP command. When adding this plugin to your presentation in <strong>File > Presentation Properties > Autorun</strong>, make sure the <strong>Name</strong> of this plugin is specified as "downplay".</p> 

<p>The command message must be formatted as follows:</p>
<code>downplay![image_URL]</code>

<p><strong>Example</strong>: <code>downplay!http://myserver.com/image1.jpg</code></p>

<p>The image will display at fullscreen until a <code>downplay!stop</code> Plugin Message command or UDP command is received.</p>


