# Klubradio

This repo is setup to

* pull the last feed of "A lényeg" show from the independent Hungarian Radio Station [Klub Rádió](https://www.klubradio.hu) on a regular basis, and to
* update a [feed JSON file](klubradio.json) with the link to the latest show.

This is required to provide a single-item JSON file for an [Amazon Alexa skill](https://www.amazon.com/alexa-skills/).

Note that this repository does not copy any content from Klub Rádió, it merely constructs a URL to the show MP3 file hosted by the station itself.

The skill is available in the [Alexa Skils](https://www.amazon.com/dp/B0CB5VPWJL/). The skill is added to the flash briefing list and can be invoked using the prompt: "Alexa, play my flash briefing".
