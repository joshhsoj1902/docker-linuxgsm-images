# 7DaysToDie

## Gotchas

### serveradmin.xml

The serveradmin.xml file (located at `/sdtd-base/layers/001-base/.local/share/7DaysToDie/Saves/serveradmin.xml` in this repo, or `/data/.local/share/7DaysToDie/Saves/serveradmin.xml` inside the docker container).

This file controls who on the server has what permissions and also is tweaked so that the webmap is accessable by default.

The problem is 7DTD also updates this file if someone creates a webaccount. And the setup of this docker container will reset this file everytime the container starts.

If this is a concern for you, I would suggest backing up `serveradmin.xml` before restarting the server, and add your backedup version to a layer in your custom dockerfile. It would also be possible for a custom dockerfile to delete the `serveradmin.xml` from the image (This will mean the webmap doesn't work by default, but since the file isn't autoupdating anymore you can just make the changes once and not worry about it again)

### worldgen

World Generation can take a long time

Env var `LGSM_QUERY_DELAY` can be set to prevent LGSM from restarting the server during world generation. For a `15360` sized world, I need to set it to 30 minutes.
