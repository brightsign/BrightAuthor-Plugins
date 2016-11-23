<p>This plugin allows you to register a client certificate with a player. Once registered, the certificate can be used when displaying remote HTML webpages. See <a href="https://gist.github.com/mtigas/952344">this page</a> for a tutorial on generating client certificates.</p>

<p><strong>Note</strong>: <em>The plugin registers the client certificate immediately as the presentation begins. However, client certificates  do not persist on the player after a reboot, so a presentation with the attached plugin will need to run after each reboot for a client certificate to be usable.</em></p>

###Adding the Plugin to your Presentation
<p>To add this plugin to a BrightAuthor presentation, navigate to <strong>File > Presentation Properties > Autorun</strong> and click <strong>Add Script Plugin</strong>. Locate and select the <em>keystore.brs</em> plugin. Specify the plugin <strong>Name</strong> as "keystore".</p>

###Adding Client Certificates to your Presentation
<p>There are two ways to add a client certificate:</p>
<ul>
<li>Add the certificate file to the presentation: Go to <strong>File > Presentation Properties > Files</strong>, click the <strong>Add File</strong> button, and select the certificate file.</li>
<li>Add the certificate file directly to the SD card: Copy the certificate file from your computer to the root of the storage device containing the presentation (e.g. "SD:/").</li>
</ul>

<p>You will also need to identify the certificate file with a user variable:</p>
<ol>
<li>Go to <strong>File > Presentation Properties > Variables</strong>.</li>
<li>Click the <strong>Add Variable</strong> button.</li>
<li>Enter the variable <strong>Name</strong> as "cert".</li>
<li>Enter the certificate filename (e.g. "my_cert.crt") as the <strong>Default Value</strong>.</li>
</ol>
