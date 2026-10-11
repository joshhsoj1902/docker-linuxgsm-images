# docker-linuxgsm-images

Related to:

- [joshhsoj1902/docker-linuxgsm-scripts](https://github.com/joshhsoj1902/docker-linuxgsm-scripts)
- [GameServerManagers/docker-gameserver](https://github.com/GameServerManagers/docker-gameserver)

The idea is to setup some public base images that I already use so that people can maybe use them too?

## Retired

These directories stay in the repo. CI does not build or publish them, and Renovate does not bump them. The list is `.github/retired-images.txt`.

The tag column is the last release CI published for that image.

| Image | Release | Replacement |
| --- | --- | --- |
| `minecraft-paper-base` | `v2.3.9-minecraft-paper-base` | [`itzg/minecraft-server`](https://github.com/itzg/docker-minecraft-server) |
| `palworld-base` | `v2.3.9-palworld-base` | [`thijsvanloef/palworld-server-docker`](https://github.com/thijsvanloef/palworld-server-docker) |
| `project-zomboid-base` | `v2.3.9-project-zomboid-base` | [`indifferentbroccoli/projectzomboid-server-docker`](https://github.com/indifferentbroccoli/projectzomboid-server-docker) |
| `sdtd-a19` | `v3.0.0-sdtd-a19` | Alpha 19.6 does not start on the current Ubuntu 24.04 gameserver image. The directory stays for a local build. |

`v2.3.9` is the last release that published Minecraft, Palworld, and Project Zomboid. `v3.0.0` skipped them because they were already retired.
