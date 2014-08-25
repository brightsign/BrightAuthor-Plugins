Overview
--------
<p>With this parser script, you can use an RSS or BSN Live Text feed to remotely modify User Variables based on player serial numbers. You can use a single feed to provide different variable values to players running the same presentation. The parser uses the example of retrieving zip codes for players by serial number, but you can adapt this function for any signage setup that requires localizing the variable values.</p>

Creating the RSS or Live Text Feed
----------------------------------
<p>Before configuring the presentation, you will need to create the RSS or Live Text feed that assigns User Variable values according to each serial number. If you do not have a BrightSign Network account, you will need to create an RSS feed.</p>
####Live Text Feed (BSN)
<ol>
<li>Log in to your BrightSign Network account.</li>
<li>Go to <strong>Create > Live Text Feeds</strong>.</li>
<li>Click <strong>Add New Feed</strong> and enter “zip” into the <strong>Name</strong> field. Note that, if you’d like to give the Live Text feed a different name, you will need to edit the parser script (see below).</li>
<li>Enter the serial number of each player in a separate <strong>Title field. You can find serial numbers listed on the bottom of each player.</li>
<li>Insert the desired User Variable value for each player in the corresponding <strong>Value fields.</li>
<li>Click the <strong>Save</strong> button once you are finished.</li>
</ol>
####RSS Feed
<p>You will need to create a “zip.xml” document and make it publicly available on the Internet so your networked players can freely retrieve the variable data. If you don’t have your own servers to host the XML document, you can also use a free Dropbox account: Please see  <a href="http://support.brightsign.biz/entries/21003508-Can-I-use-a-Dropbox-account-with-my-BrightSign">this FAQ</a> to learn more about publicly hosting files with Dropbox. </p>
<ol>
<li>Open the example “zip.xml” file using a text editor program (Notepad, TextMate, etc.).</li>
<li>Add new <code>&lt;item&gt;</code> <code>&lt;/item&gt;</code> tags for each of your players. </li>
<li>Add <code>&lt;title&gt;</code> and <code>&lt;description&gt;</code> tags between each set of <code>&lt;item&gt;</code> tags (as shown in the example entry). </li>
<li>Specify a player serial number within each set of <code>&lt;title&gt;</code> tags. You can find serial numbers listed on the bottom of each player.</li>
<li>Specify a zip code (or other local variable value) within each corresponding set of <code>&lt;description&gt;</code> tags.</li>
<li>Save and close the “zip.xml” file when you are finished.</li>
<strong>Note</strong>: <em>The channel <code>&lt;title&gt;</code> and <code>&lt;description&gt;</code> tags are named “zip” by default. You can change these if desired. However, if you’d like to change the “zip.xml” file name, you will need to edit the parser script (see below).</em>
</ol>

Configuring the Presentation
----------------------------
<p>You will need to add the parser script to the presentation and create two User Variables: “zipcode” and “ziplistlocation”.</p>
####Adding the Parser Script
<ol>
<li>Go to <strong>File > Presentation Properties > Data Feeds</strong>. Click <strong>Add Data Feed</strong>.</li>
<li>Enter a <strong>Feed name</strong> for the Data Feed.</li>
<li>Enter the following URL in the <strong>Feed Specification</strong> field: file:///autoplugins.brs</li>
<strong>Note</strong>: <em>Since we’re only interested in adding a parser script to the presentation, having a working Data Feed is not necessary. Therefore, the goal here is simply to have URL that will always be valid, rather than having an actual Data Feed to use or display in the presentation.</em>
<li>Choose an <strong>Update Interval</strong>.</li>
<li>Use the <strong>Browse</strong> button to locate and select the parser script.</li>
<li>Enter “urlchange” in the <strong>Parser Function Name</strong> field.</li>
<li>Click <strong>OK</strong>.</li>
</ol>
####Adding the User Variables
<ol>
<li>While in the <strong>Presentation properties</strong> window, navigate to the <strong>Variables</strong> tab.</li>
<li>Use the <strong>Add Variable</strong> button to add two variables.</li>
<li>Specify the <strong>Name</strong> of the first variable as “zipcode”. Set the <strong>Default value</strong> to a value you wish the presentation to use if it cannot connect to the RSS or Live Text feed.</li>
<li>Specify the <strong>Name</strong> of the second variable as “ziplistlocation”. Set the <strong>Default value</strong> to the URL of the RSS or Live Text feed you created in the previous section.</li>
<strong>Note</strong>: <em>If you created the feed using the BrightSign Network, you can retrieve the URL by signing into the WebUI and navigating to <strong>Create > Live Text Feeds</strong>. Click <strong>Properties</strong> beneath the feed you created and copy/paste the displayed URL.</em>
</ol>
(optional) Customizing the parser script
----------------------------------
<p>To edit the “urlchange.bpf” parser script, open it with a text editor program (Notepad, TextMate, etc.).</p>
####Changing the name of “zip” RSS feed or Data Feed
<p>Locate the line that states the following: <code>&lt;ziplist$="zip.xml"&gt;</code>. Change the name of the “zip.xml” file (while leaving the quotes intact) to match the desired name of the RSS .xml file or the BSN Live Text feed name.</p>
####Changing the name of the “zipcode” User Variable
<p>Locate the line that states the following: <code>&lt;if userVariables.DoesExist(“zipcode”) then&gt;</code>. Change “zipcode” on this line and the following line to the desired value. Make sure it matches the name of the User Variable in the presentation.</p>
####Changing the name of the “ziplistlocation” User Variable
<p>Locate the line that states the following: <code>&lt;if userVariables.DoesExist(“ziplistlocation”) then&gt;</code>. Change “ziplistlocation” on this line and the following line to the desired value. Make sure it matches the name of the User Variable in the presentation.</p>
