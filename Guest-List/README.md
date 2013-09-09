Overview
--------
<p>This plug-in allows you to display a dynamic, numbered list of first and last names. This list can be remotely updated by editing a publicly accessible XML file. </p>

Creating a List of Names
------------------------

<p>Before publishing the presentation, you will need to create a list of names as an XML document titled “list.xml”. If you are unfamiliar with creating XML documents, you can use the “list.xml” file attached with these instructions as a template:</p>
<ol>
<li>Open the “list.xml” file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Enter a <firstname> and <lastname> for each name between the <customer> and </customer> tags. Note that you can only place one set of <firstname> and <lastname> tags between a single set of <customer> tags. Also note that the order of names in the XML list is the same order in which names will appear in the presentation.</li>
<li>If you need to add fewer than ten names to the list, remove the additional <customer> </customer> entries and change the <list total=”10”> number on the second line to the number of <customer> entries in your list.</li>
<li>If you need to add more than ten names to the list, copy and paste existing four-line <customer> </customer> entries to the document. Make sure extra entries are posted before the </list> tag at the end of the document and are not posted between other <customer> </customer> tags. Then, change the <list total=”10”> number on the second line to the number of <customer> tags in your list.</li>
<li>Save the “list.xml” document.</li>
</ol>

Hosting the XML Document
------------------------
<p>You will need to make the “list.xml” document publicly available on the Internet so your networked player(s) can freely retrieve the list data. If you don’t have your own servers to host the XML document, you can also use a free Dropbox account: Please see <a href ="http://support.brightsign.biz/entries/21003508-Can-I-use-a-Dropbox-account-with-my-BrightSign">this FAQ</a> to learn more about publicly hosting files with Dropbox.

Adding the Data Feed and Plug-In to your Presentation
------------------------------------------------------
<p>Next, you will need to add the plug-in script to the presentation and specify how often the player will contact the server to update the content of the list.</p>
<ol>
<li>In BrightAuthor, navigate to the File > Presentation properties window. Select the Data Feeds tab and click the Add Data Feed button.</li>
<li>Enter a Feed name for the Data Feed (e.g. “Guest List”).</li>
<li>Enter the URL of your hosted XML document in the Feed Specification field.</li>
<li>Choose an Update Interval. This will determine how often the player will refresh the guest list using the hosted XML document.</li>
<li>Use the Browse button to locate and select the “list.brs” plug-in script.</li>
<li>Enter “list” into the Parser Function Name field.</li>
<li>Click OK.</li>
</ol>

Creating a Live Text State
--------------------------
<p>Now you will need to create a Live Text state that displays the dynamic guest list. For a complete description of Live Text states, please see the <a href="http://support.brightsign.biz/entries/314526-brightsign-user-guides-troubleshooting">BrightAuthor User Guide</a>.</p>
<ol>
<li>Click the interactive option to the right of the playlist to make the presentation interactive.</li>
<li>Select the other tab in the Media Library section.</li>
<li>Drag and drop the Live Text icon onto the playlist area.</li>
<li>Enter a State name and specify a Background Image for the list text.</li>
<li>Create a text box and set the Type to Live Text Data, choosing the “Guest List” Data Feed you added to the presentation in the previous step.</li>
<li>Select Item index and set the field to 1. This sets the text box to display the first name in the XML document you created.</li>
<li>Fit the text box to the first list area in the image.</li>
<li>Click Add Item to create a new text item and repeat Steps 5-7. Do this for every name in your list. Note that the Item index number will increase by one for each new text item you create.</li>
<li>Click OK once you are finished adding list names. Expand and publish the presentation as desired.</li>
</ol>

(Optional) Customizing the Data Feed Parser
-------------------------------------------
<p>If you’d like to create a dynamic list with attributes other than first and last names, you will need to edit both the “list.brs” script and the “list.xml” document. The instructions below will use the example of adding a “job title” attribute to each list item. This example will also include removing the list numbers to illustrate how to remove one of the default attributes.</p>
<p> </p>
*Editing the .brs script*
<ol>
<li>Open the “list.brs” plug-in file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Locate the line that states itemsbyindex[count]=str(count+1)…</li>
<li>Add the following to the end of the line: “+”, ”+item.jobtitle.GetText()”. The first plus sign will add a comma and space after the last name. The second plus sign will add the “jobtitle” attribute to each list item.</li>
<li>Remove the following text from the line: “str(count+1)+”. ”+”. Doing this will remove both the number and the period after the number from the beginning of each list item.</li>
<li>Save and close the “list.brs” file when you are finished.</li>
</ol>
<p> </p>
*Editing the XML document*
<ol>
<li>Open the “list.xml” file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Insert a new set of <jobtitle> </jobtitle> tags between each <customer> </customer> tag. The <jobtitle> tags should be the exact same format as the <firstname> </firstname> and <lastname> </lastname> tags.</li>
<li>Save and close the “list.xml” file when you are finished.</li>
</ol>


