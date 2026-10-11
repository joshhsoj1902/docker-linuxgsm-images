# docker-linuxgsm-images

Related to:

- [joshhsoj1902/docker-linuxgsm-scripts](https://github.com/joshhsoj1902/docker-linuxgsm-scripts)
- [GameServerManagers/docker-gameserver](https://github.com/GameServerManagers/docker-gameserver)

The idea is to setup some public base images that I already use so that people can maybe use them too?

## Retired

These directories stay in the repo. CI does not build or publish them, and Renovate does not bump them. The list is `.github/retired-images.txt`.

The tag column is the last image CI pushed. `latest-<image>` still points at that same digest.

| Image | Last published | Replacement |
| --- | --- | --- |
| `minecraft-paper-base` | `0.0.16851365842-minecraft-paper-base` | [`itzg/minecraft-server`](https://github.com/itzg/docker-minecraft-server) |
| `palworld-base` | `0.0.16851365842-palworld-base` | [`thijsvanloef/palworld-server-docker`](https://github.com/thijsvanloef/palworld-server-docker) |
| `project-zomboid-base` | `0.0.16851365842-project-zomboid-base` | [`indifferentbroccoli/projectzomboid-server-docker`](https://github.com/indifferentbroccoli/projectzomboid-server-docker) |
| `sdtd-a19` | `v3.0.0-sdtd-a19` | Alpha 19.6 does not start on the current Ubuntu 24.04 gameserver image. The directory stays for a local build. |

`minecraft-paper-base`, `palworld-base`, and `project-zomboid-base` were last pushed on 2025-08-09. The Project Zomboid gameserver digest bump later that day never produced a tag, so `0.0.16851365842-project-zomboid-base` is the image from before that bump. The Actions run for that publish is no longer available.
