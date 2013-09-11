Overview
--------
<p>This plug-in allows you to display a dynamic, numbered list of first and last names. This list can be remotely updated by editing a publicly accessible XML file. </p>

Creating a List of Names
------------------------

<p>Before publishing the presentation, you will need to create a list of names as an XML document titled “list.xml”. If you are unfamiliar with creating XML documents, you can use the “list.xml” file attached with these instructions as a template:</p>
<ol>
<li>Open the “list.xml” file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Enter a <code>&lt;firstname&gt;</code> and <code>&lt;lastname&gt;</code> for each name between the <code>&lt;customer&gt;</code> and <code>&lt;/customer&gt;</code> tags. Note that you can only place one set of <code>&lt;firstname&gt;</code> and <code>&lt;lastname&gt;</code> tags between a single set of <code>&lt;customer&gt;</code> tags. Also note that the order of names in the XML list is the same order in which names will appear in the presentation.</li>
<li>If you need to add fewer than ten names to the list, remove the additional <code>&lt;customer&gt;</code> <code>&lt;/customer&gt;</code> entries and change the <code>&lt;list total=”10”&gt;</code> number on the second line to the number of <code>&lt;customer&gt;</code> entries in your list.</li>
<li>If you need to add more than ten names to the list, copy and paste existing four-line <code>&lt;customer&gt;</code> <code>&lt;/customer&gt;</code> entries to the document. Make sure extra entries are posted before the <code>&lt;/list&gt;</code> tag at the end of the document and are not posted between other <code>&lt;customer&gt;</code> <code>&lt;/customer&gt;</code> tags. Then, change the <code>&lt;list total=”10”&gt;</code> number on the second line to the number of <code>&lt;customer&gt;</code> tags in your list.</li>
<li>Save the “list.xml” document.</li>
</ol>


Hosting the XML Document
------------------------
<p>You will need to make the “list.xml” document publicly available on the Internet so your networked player(s) can freely retrieve the list data. If you don’t have your own servers to host the XML document, you can also use a free Dropbox account: Please see <a href ="http://support.brightsign.biz/entries/21003508-Can-I-use-a-Dropbox-account-with-my-BrightSign">this FAQ</a> to learn more about publicly hosting files with Dropbox.</p>

Adding the Data Feed and Plug-In to your Presentation
------------------------------------------------------
<p>Next, you will need to add the plug-in script to the presentation and specify how often the player will contact the server to update the content of the list.</p>
<ol>
<li>In BrightAuthor, navigate to the <strong>File > Presentation properties</strong> window. Select the <strong>Data Feeds</strong> tab and click the <strong>Add Data Feed</strong> button.</li>
<li>Enter a <strong>Feed name</strong> for the Data Feed (e.g. “Guest List”).</li>
<li>Enter the URL of your hosted XML document in the <strong>Feed Specification</strong> field.</li>
<li>Choose an <strong>Update Interval</strong>. This will determine how often the player will refresh the guest list using the hosted XML document.</li>
<li>Use the <strong>Browse</strong> button to locate and select the “list.brs” plug-in script.</li>
<li>Enter “list” into the <strong>Parser Function Name</strong> field.</li>
<li>Click <strong>OK</strong>.</li>
</ol>

Creating a Live Text State
--------------------------
<p>Now you will need to create a Live Text state that displays the dynamic guest list. For a complete description of Live Text states, please see the <a href="http://support.brightsign.biz/entries/314526-brightsign-user-guides-troubleshooting">BrightAuthor User Guide</a>.</p>
<ol>
<li>Click the <strong>interactive</strong> option to the right of the playlist to make the presentation interactive.</li>
<li>Select the <strong>other</strong> tab in the <strong>Media Library</strong> section.</li>
<li>Drag and drop the <strong>Live Text</strong> icon onto the playlist area.</li>
<li>Enter a <strong>State name</strong> and specify a <strong>Background Image</strong> for the list text.</li>
<li>Create a text box and set the <strong>Type</strong> to <strong>Live Text Data</strong>, choosing the “Guest List” Data Feed you added to the presentation in the previous step.</li>
<li>Select <strong>Item index</strong> and set the field to 1. This sets the text box to display the first name in the XML document you created.</li>
<li>Fit the text box to the first list area in the image.</li>
<li>Click <strong>Add Item</strong> to create a new text item and repeat <strong>Steps 5-7</strong>. Do this for every name in your list. Note that the <strong>Item index</strong> number will increase by one for each new text item you create.</li>
<li>Click <strong>OK</strong> once you are finished adding list names. Expand and publish the presentation as desired.</li>
</ol>

(Optional) Customizing the Data Feed Parser
-------------------------------------------
<p>If you’d like to create a dynamic list with attributes other than first and last names, you will need to edit both the “list.brs” script and the “list.xml” document. The instructions below will use the example of adding a “job title” attribute to each list item. This example will also include removing the list numbers to illustrate how to remove one of the default attributes.</p>
<p> </p>
*Editing the .brs script*
<ol>
<li>Open the “list.brs” plug-in file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Locate the line that states <code>itemsbyindex[count]=str(count+1)…</code></li>
<li>Add the following to the end of the line: <code>“+”, ”+item.jobtitle.GetText()”</code>. The first plus sign will add a comma and space after the last name. The second plus sign will add the “jobtitle” attribute to each list item.</li>
<li>Remove the following text from the line: <code>“str(count+1)+”. ”+”</code>. Doing this will remove both the number and the period after the number from the beginning of each list item.</li>
<li>Save and close the “list.brs” file when you are finished.</li>
</ol>
<p> </p>
*Editing the XML document*
<ol>
<li>Open the “list.xml” file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Insert a new set of <code>&lt;jobtitle&gt;</code>  <code>&lt;/jobtitle&gt;</code>  tags between each <code>&lt;customer&gt;</code>  <code>&lt;/customer&gt;</code>  tag. The <code>&lt;jobtitle&gt;</code>  tags should be the exact same format as the <code>&lt;firstname&gt;</code> <code>&lt;/firstname&gt;</code>  and <code>&lt;lastname&gt;</code> <code>&lt;/lastname&gt;</code> tags.</li>
<li>Save and close the “list.xml” file when you are finished.</li>
</ol>


