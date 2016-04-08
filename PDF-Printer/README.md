This plugin allows you to print PDF documents to a networked printer using Plugin Message commands. It works by opening up a TCP socket on port 9100 and sending the PDF data to the specified IP address of the networked printer.

See the <em>printPDF.bpf</em> file in this repository for an example of how to use this plugin in a BrightAuthor presentation. 

###Adding the Plugin to your Presentation
<p>To add this plugin to your BrightAuthor presentation, navigate to <strong>File > Presentation Properties > Autorun</strong> and click <strong>Add Script Plugin</strong>. Locate and select the PDF Printer plugin. Specify the plugin <strong>Name</strong> as "PrintPDF".</p>

###Adding PDF Files to your Presentation
<p>Navigate to <strong>File > Presentation Properties > Autorun</strong>. Use the <strong>Add File</strong> button to locate and select the PDFs that you wish to print.</p>

###Configuring the Printer IP Address for the Presentation
<p>The IP address of the network printer is configured with a "printerIP" User Variable. To add this variable, navigate to <strong>File > Presentation Properties > Variables</strong> and click <strong>Add Variable</strong>. Specify the variable <strong>Name</strong> as "printerIP" and enter the IP address of the printer as the <strong>Default Value</strong>.</p>

###Executing Print Commands
<p>To trigger a print, attach a Send Plugin Message command to an event or state. The message body of the command must be "printFiles".</p> 

<p>When the plugin receives this command, it will send all PDFs attached to the presentation to the "printerIP" address on TCP port 9100.</p>

<p>When the plugin finishes transmitting the PDFs to the specified IP address, it will return a "printPDFsFinishedEvent" message. This allows you to trigger a transition with a Plugin Message event when the print is complete.</p>
