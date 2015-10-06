Overview
------------

This plugin allows a BrightSign to operate and control a projector using the [PJLink](http://pjlink.jbmia.or.jp/english/) standard. PJLink commands are sent as hexadecimal-formatted messages over the local network using a TCP connection.

## Installation

In BrightAuthor, while editing a presentation, open the Autorun presentation properties at **File > Presentation Properties > Autorun**.

1. Add a new *Script Plugin*:

	* **Name**: _pjlink_ (in all lowercase letters)
	* **Path**: Select `pjlink.brs` as the path.

2. Set the PJLink IP Address and optionally the TCP port number. Create two **User Variables** by going to **File > Presentation Properties > Variables** and adding the following:
	* **pjlink_projector_ip** - set the default to your projector's IP Address
	* **pjlink_projector_port** - (optional) set to the TCP port number to address the projector. If this variable is not set the plugin will use port **4352**.


## Usage

This plugin includes two named commands: "poweron" and "poweroff". Otherwise actual raw PJLink commands can be sent as well.

There are two methods of usage for this plugin:

1. Using Send Plugin Message in an interactive presentation:
	* **Advanced > Send > Send Plugin Message**. Select the "pjlink" plugin. In the parameters block, enter on of the following:
	* **poweron**
	* **poweroff**
	* Any raw PJLink command, such as **INPT 32** to switch to the digital input.

2. Direct messaging with UDP datagrams. Commands must be prefixed with "pjlink!":

		# Named commands from this plugin:
		# power the projector on and off
		pjlink!poweron
		pjlink!poweroff
		
		# "Raw" PJLink commands. Format: pjlink!<command>
		# power the projector on and off:
		pjlink!POWR 1
		# power the projector off:
		pjlink!POWR 0
		# switch inputs:
		pjlink!INPT 11
		pjlink!INPT 32

## Testing

The [PJLink Test software](http://pjlink.jbmia.or.jp/english/dl.html) can be used to confirm commands are being sent/processed not the projector end. (Configure the Network under the Set up menu of the PJLinkTest4PJ exe.)

With telnet enabled on you can see messages from the pjlink plugin printed to the screen. Connection details (IP and port) as well as hex-encoded commands are printed.