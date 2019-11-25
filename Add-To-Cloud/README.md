# Adding a BrightAuthor Classic player to BSN.cloud

Add this plugin to a presentation in order to add a player to the control cloud, content cloud, or both.

The plugin reads cloudParams.json and writes its values to the registry. "ControlCloud_cloudParams.json" is an example of this file that only uses the BSN control cloud.
"ContentCloud_cloudParams.json" uses BSN for both control and content.

If you'd only like the player to use the control cloud, and not the content cloud, set "contentCloud" to false in cloudParams.json or just delete it.

## Steps
1. Create a BSN setup in BrightAuthor:Connected
2. Copy three values from the current-sync.json in the setup and put them in cloudParams.json:  
account -> a  
group -> g  
bsnRegistrationToken -> bsnrt  
3. Publish a presentation with the plugin to a card, and put cloudParams.json at the root of the card.