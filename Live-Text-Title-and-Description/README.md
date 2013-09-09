Overview
-------------
<p>If you choose to display Live Text Data in a Live Text state, you can only display item descriptions, not item titles. This plug-in allows you to display both the title and description of an item in a Live Text State.</p>
<p><strong>Note</strong>: <em>This plug-in only works with the Live Text Feed feature on the BrightSign Network.</em></p>

Adding the Data Feed and Plug-In to your Presentation
---------------------------------------------------
<p>First, you will need to add your BSN Data Feed and plug-in script to the presentation.</p>
<ol>
<li>In BrightAuthor, navigate to the <strong>File > Presentation Properties </strong>window. Select the <strong>Data Feeds</strong> tab and click the <strong>Add Data Feed</strong> button.</li>
<li>Enter a <strong>Feed</strong> name for the Data Feed.</li>
<li>In the <strong>Feed Specification</strong> field, select <strong>Live Data Feed</strong> and choose a feed you created in BrightAuthor or on the BrightSign Network.</li>
<li>Choose an <strong>Update Interval</strong>. This will determine how often the player will refresh the Live Text Data.</li>
<li>Use the <strong>Browse</strong> button to locate and select the “livetextboth.brs” plug-in script.</li>
<li>Enter “livetextboth” into the <strong>Parser Function Name</strong> field.</li>
<li>Click <strong>OK</strong>.</li>
</ol>

Displaying the Live Text Data in BrightAuthor
------------------------------------------------------------
<p>Now you can create a Live Text state that displays both the item title and item description of the Live Text Data. </p>
<p><strong>Note</strong>: <em>For a complete description of Live Text states, please see the <a href="http://support.brightsign.biz/entries/314526-brightsign-user-guides-troubleshooting">BrightAuthor User Guide</a>.</em></p>
<ol>
<li>Click the <strong>interactive</strong> option to the right of the playlist to make the presentation interactive.</li> 
<li>Select the <strong>other</strong> tab in the <strong>Media Library</strong> section.</li>
<li>Drag and drop the <strong>Live Text</strong> icon onto the playlist area.</li>
<li>Enter a <strong>State name</strong> and specify a <strong>Background Image</strong> for the list text.</li>
<li>Create a text box and set the <strong>Type</strong> to <strong>Live Text Data</strong>, choosing the Data Feed you created in the previous step.</li>
<li>Select <strong>Item index</strong> and set the field to 1. This text box will display the title of the first item.</li>
<li>Click <strong>Add Item</strong> and set the <strong>Item index</strong> to 2. The first text box will display the <em>title</em> of the first item, while the second text box will display the <em>description</em> of the first item. Note that, for the parser to work correctly, you must use the <strong>Item index</strong>, rather than the <strong>Item title</strong>, to specify what will be displayed.</em></li>
<li>Create as many text boxes as you need. Note that, with this parser, the <strong>Item index</strong> refers to items in multiples of two:</li>
</ol>
<ul>
<li>Item index #1 – item 1 title</li>
<li>Item index #2 – item 1 description</li>
<li>Item index #3 – item 2 title</li>
<li>Item index #4 – item 2 description</li>
<li>Item index #5 – item 3 title</li>
<li>Item index #6 – item 3 description</li>
<li>Item index #7 – item 4 title</li>
<li>Item index #8 – item 4 description</li>
<li>Item index #9 – item 5 title</li>
<li>Item index #10 – item 5 description</li>
<li>Etc…</li>
</ul>
<ol start="9">
<li>Click <strong>OK</strong> once you are finished adding Live Text items.</li>
</ol>
