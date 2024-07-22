# Backup gomplated config files
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm mv /data/Zomboid/Server/pzserver.ini /data/Zomboid/Server/pzserver.gomplated.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm mv /data/Zomboid/Server/pzserver_SandboxVars.lua /data/Zomboid/Server/pzserver_SandboxVars.gomplated.lua
# docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm mv /data/Zomboid/Server/pzserver_spawnregions.lua /data/Zomboid/Server/pzserver_spawnregions.gomplated.lua

# Restart zomboid server
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec -u 1000 linuxgsm bash /app/pzserver restart

# Not sure if I need this sleep
sleep 30

# Backup default confgs file
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm mv /data/Zomboid/Server/pzserver.ini /data/Zomboid/Server/pzserver.default.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm mv /data/Zomboid/Server/pzserver_SandboxVars.lua /data/Zomboid/Server/pzserver_SandboxVars.default.lua
# docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm mv /data/Zomboid/Server/pzserver_spawnregions.lua /data/Zomboid/Server/pzserver_spawnregions.default.lua
# Restore gomplated config file
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm cp /data/Zomboid/Server/pzserver.gomplated.ini /data/Zomboid/Server/pzserver.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm cp /data/Zomboid/Server/pzserver_SandboxVars.gomplated.lua /data/Zomboid/Server/pzserver_SandboxVars.lua
# docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm cp /data/Zomboid/Server/pzserver_spawnregions.gomplated.lua /data/Zomboid/Server/pzserver_spawnregions.lua

# Restart zomboid server
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec -u 1000 linuxgsm bash /app/pzserver restart

sleep 30

# Remove RCONPassword lines since they will never match
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm sed -i '/RCONPassword/d' /data/Zomboid/Server/pzserver.default.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm sed -i '/RCONPassword/d' /data/Zomboid/Server/pzserver.gomplated.ini

# Remove "ResetID" lines since they will never match
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm sed -i '/Reset ID/d' /data/Zomboid/Server/pzserver.default.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm sed -i '/Reset ID/d' /data/Zomboid/Server/pzserver.gomplated.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm sed -i '/ResetID/d' /data/Zomboid/Server/pzserver.default.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm sed -i '/ResetID/d' /data/Zomboid/Server/pzserver.gomplated.ini

# do diffs
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm diff -w --color=always --unified=3 /data/Zomboid/Server/pzserver.default.ini /data/Zomboid/Server/pzserver.gomplated.ini
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm diff -w --color=always --unified=3 /data/Zomboid/Server/pzserver_SandboxVars.default.lua /data/Zomboid/Server/pzserver_SandboxVars.gomplated.lua
docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm ls -ltr /data/Zomboid/Server

# It looks like the spawn regions file doesn't exist by default
# docker compose -f images/project-zomboid-base/.tests/docker-compose.yml exec linuxgsm diff -w --color=always --unified=3 /data/Zomboid/Server/pzserver_spawnregions.default.lua /data/Zomboid/Server/pzserver_spawnregions.gomplated.lua

