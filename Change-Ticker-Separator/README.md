<p>This plugin allows you to change the separator symbol for all scrolling tickers in a presentation. By default, each string in a scrolling ticker is separated by a diamond symbol; use this plugin to change the separator to a circle or square.</p>

###Adding the Plugin to your Presentation
<p>To add this plugin to your BrightAuthor presentation, navigate to <strong>File > Presentation Properties > Autorun</strong> and click <strong>Add Script Plugin</strong>. Locate and select the <em>ChangeSeparator.brs</em> plugin file. Specify the plugin <strong>Name</strong> as "customT".</p>

###Changing the Separator Symbol
<p>The plugin sets the separator symbol to a circle by default. To change this behavior, open the <em>ChangeSeparator.brs</em> plugin file with a plain-text editing program (Notepad, TextEdit, etc.). Locate line 29, which states <code>s.symbol = ":circle:"</code>, and change this line to any of the following:</p>
<ul>
<li><code>s.symbol = ":square:"</code></li>
<li><code>s.symbol = ":diamond:"</code></li>
<li><code>s.symbol = ":circle:"</code></li>
</ul>
<p>Make sure to save the plugin file after you've edited it.</p>
