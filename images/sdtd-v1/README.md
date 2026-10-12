# 7 Days to Die (V1 / Steam branch `v1.4`)

Use this image when the dedicated server should stay on the V1 game line.

Steam still publishes `v1.4` on app [294420](https://steamdb.info/app/294420/depots/). That build expects the older `serverconfig.xml` shape (`GameDifficulty`, `DropOnDeath`, `DeathPenalty`, …). The current `sdtd-base` image targets V3 and uses `SandboxCode` instead; pairing V3 config with a `v1.4` binary crashes at startup (`GameOptionsManager.ValidateFoV`).

Default branch pin:

```
ENV LGSM_SERVER_BRANCH=v1.4
```

For current stable (V3.x), use `sdtd-base` and leave the branch at `public` (or pin `v3.3.0` / similar).

## Gotchas

### serveradmin.xml

The serveradmin.xml file (located at `/sdtd-v1/layers/001-base/.local/share/7DaysToDie/Saves/serveradmin.xml` in this repo, or `/data/.local/share/7DaysToDie/Saves/serveradmin.xml` inside the docker container).

This file controls who on the server has what permissions and also is tweaked so that the webmap is accessable by default.

The problem is 7DTD also updates this file if someone creates a webaccount. And the setup of this docker container will reset this file everytime the container starts.

If this is a concern for you, I would suggest backing up `serveradmin.xml` before restarting the server, and add your backedup version to a layer in your custom dockerfile. It would also be possible for a custom dockerfile to delete the `serveradmin.xml` from the image (This will mean the webmap doesn't work by default, but since the file isn't autoupdating anymore you can just make the changes once and not worry about it again)
