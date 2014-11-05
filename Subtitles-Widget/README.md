<h2>README</h2>

<p>This plugin allows you to display subtitles for a video file using an attached <em>.txt</em> file. It also supports subtitles for multiple video files per presentation.</p>

<h4>Creating the subtitles</h4>
<p>Create a new text file using Notepad or another program. Use the same filename (excepting the extension) as the associated video file: For example, if you had two video files named "Information_Clip.mov" and "Transition.mp4", you would name the associated subtitle files "Information_Clip.txt" and "Transition.txt", respectively.</p>

<p>Above each line of subltitle text, specify the video time code at which the text should appear, as in the following example:</p>
<p>00:00:00:00</p>
<p>This is the first line of text.</p>
<p>00:00:04:23</p>
<p>This is the second line of text.</p>
<p>00:00:08:23</p>
<p>This is the third line of text.</p>
<p>00:00:11:18</p>
<p>This is the fourth line of text.</p>
<p>00:00:14:18</p>
<p>This is the fifth line of text.</p>
<p>Note that each time code and line of text must be separated by a carriage return ("/r/n") in the text document. The time codes are specified using the following format: <code>hours:minutes:seconds:frames</code></p>

<p>To insert points where no subtitles are displayed, specify a time code followed by a blank line.</p>

<h4>Adding the Plugin and Subtitles</h4>
<p>Follow these steps to setup up the plug-in in your BrightAuthor presentation</p>
<ol>
<li>Navigate to <strong>File > Presentation Properties > Autorun</strong>.</li>
<li>Click <strong>Add Script Plugins</strong> and locate the "Subtitles_Widget.brs" file. Ensure that the plugin <strong>Name</strong> is specified as "custom".</li>
<li>Navigate to <strong>File > Presentation Properties > Files</strong>. Use the <strong>Add File</strong> button to add a <em>.txt</em> subtitle file for each video file you wish to subtitle.</li>
</ol>
<p>Subtitles will display whenever a subtitled video plays. There is no need to create the text widget or trigger the plugin with commands.</p>



