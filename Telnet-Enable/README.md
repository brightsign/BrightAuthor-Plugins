README
-------

<p>This plugin allows you to enable or disable Telnet on a BrightSign player. You can use Telnet to observe player logging over the local network. Normally, this can only be captured via the serial log.</p> 

<p>The plugin is triggered using a Plugin Message command or UDP command directed at port 555. The plugin accepts the following messages:</p>
<ul>
<li><code>telnet!on</code></li>
<li><code>telnet!off</code><li>
<li><code>telnet!reboot</code></li>
</ul>
<p>The player must be rebooted before the changes to Telnet settings go into effect.</p>
