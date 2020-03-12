# Publish Node
This plugin allows you to run a chronode application from within a BrightAuthor presentation.

1. Add the plugin to presentation properties.
1. Package your application as "node.zip"
1. Add the zip to the presentation.

It's recommended that you use webpack or another bundler to keep your application small and performant. This also speeds up the zipping and unzipping process dramatically since there are much fewer files when "node_modules" is bundled into a single script.

Chronode apps work similarly to electron apps. [Head over to the BrightSign documentation to learn more about how they work on a BrightSign.](https://docs.brightsign.biz/display/DOC/Node.js)