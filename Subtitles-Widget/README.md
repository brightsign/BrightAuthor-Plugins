<h2>README</h2>

<p>This plugin allows you to display subtitles for a video file using an attached <em>.txt</em> file. It also supports subtitles for multiple video files per presentation.</p>

<h4>Creating the Subtitles</h4>
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
<p>Follow these steps to add the plugin and subtitle files to your BrightAuthor presentation</p>
<ol>
<li>Navigate to <strong>File > Presentation Properties > Autorun</strong>.</li>
<li>Click <strong>Add Script Plugins</strong> and locate the "subtitles_widget.brs" file. Ensure that the plugin <strong>Name</strong> is specified as "custom".</li>
<li>Navigate to <strong>File > Presentation Properties > Files</strong>. Use the <strong>Add File</strong> button to add a <em>.txt</em> subtitle file for each video file you wish to subtitle.</li>
</ol>
<p>The subtitles will now display whenever a subtitled video plays. There is no need to create the text widget or trigger the plugin with commands.</p>

<h4>Resizing the Subtitle Widget</h4>
<p>By default, the text widget that displays the subtitles is sized using an "action safe" area, ensuring that the text remains within a viewable area on the screen. You may wish to resize this zone so that it better fits the size and layout of your presentation.</p>

<p>To resize the text widget, locate line 45 in the plugin, which specifies the size of the widget by creating an <em>roRectangle</em> object. You can manually input the size and location of the widget by editing the object creation parameters: <code>CreateObject("roRectangle", x, y, width, height)</code></p>

<p><strong>Example</strong>: The following edit creates a subtitle widget that occupies a strip at the bottom of a 1920x1080 display.</p>
<code>s.rect=CreateObject("roRectangle", 0, 900, 1920, 180)</code>


