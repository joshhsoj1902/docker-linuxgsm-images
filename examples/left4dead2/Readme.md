# Left4Dead2

## Usage

Make any desired changes to the l4d2 compose file. once you're ready run `docker compose up`.

### Notes

- The compose file defaults to 8 player co-op, but this can be canged to vanilla if you desire.
- If you want to set yourself as an admin, You'll need to extend this docker image and update file `images/l4d2-8coop/layers/001-base/serverfiles/left4dead2/addons/sourcemod/config/admins_simple.ini`
