Overview
-------------
<p>By default, when displaying an RSS feed in a Live Text state, you cannot use index numbers to choose which feed item(s) to display. This plug-in converts a standard RSS feed into the same format as a BSN Live Text feed, allowing you to display RSS feed items by index number.</p>

Adding the RSS Feed and Plug-In
--------------------------------------------
<p>First, you will need to add your RSS feed and plug-in script to the presentation.</p>
<ol>
<li>In BrightAuthor, navigate to the <strong>File > Presentation properties</strong> window. Select the <strong>Data Feeds</strong> tab and click the <strong>Add Data Feed</strong> button.</li>
<li>Enter a <strong>Feed name</strong> for the Data Feed.</li>
<li>In the </strong>Feed Specification</strong> field, select <strong>URL</strong> and enter the address of the desired RSS feed.</li>
<li>Choose an <strong>Update Interval</strong>. This will determine how often the player will refresh the Live Text state using the feed.</li>
<li>Use the <strong>Browse</strong> button to locate and select the “rssconverter.brs” plug-in script.</li>
<li>Enter “rss” into the <strong>Parser Function Name</strong> field.</li>
<li>Click <strong>OK.</strong></li>
</ol>

<p>Now you can create a Live Text state that displays RSS items by index. Under <strong>Type</strong>, choose Live Text Data and select the feed you just added. Then specify the Item index as desired.</p>
<strong>Note</strong>:<em>When using this parser on a Data Feed, you cannot display items from that feed using the Item title.</em>
