These are instructions for using the [Docker](https://www.docker.com) container to run an [AresMUSH](https://aresmush.com) development environment on your local PC/Mac.

> **Note:** This setup is only intended for local development only, and is **not** suitable for a real production game.

## Initial Setup

To set up the container for the first time:

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop).

2. Clone this repo to your local PC/Mac. You can use [GitHub Desktop](https://desktop.github.com/) or any other GitHub tool.

3. Clone the aresmush and ares-webportal code repos INTO the ares-docker directory. Your directory should now look like this:
  
```
    ares-docker
      - aresmush
      - ares-webportal
      - data
```

4. Copy the `aresmush/install/game.distr` directory to create a new folder `aresmush/game`.

5. From the ares-docker directory, start the container using this command:

```   
    docker-compose up
```

> Note: All commands can be run in Windows PowerShell or Mac Terminal.

6. In a new PowerShell/Terminal window, use this command to launch a shell connected to the container:
 
```
     docker exec -it ares-docker_game_1 /bin/bash -l
```

7. Within the **docker shell**, run these commands to set up the game:
 
```
    cd aresmush
    bundle install
    bundle exec rake configure $*
      - Use 127.0.0.1 for the host
      - Use default ports (this setup will not work with different ports)
      - Ignore the warning about the web portal directory not being found - that's OK.
    bundle exec rake init
```

## Running the Game

After initial setup, here are the commands you'll want to use whenever you want to run the game.

> Note: If you still have the ares container and shell running from the initial setup, you can skip step 1&2.

1. Start the container and database:
 
```
    docker-compose up
```

2. In a new PowerShell/Terminal window, launch a shell connected to the container:

```
    docker exec -it ares-docker_game_1 /bin/bash -l
```

3.  Within the **docker shell**, run these commands to start the game:
 
```
    cd aresmush
    bundle install
    bundle exec rake startares[disableproxy]
```

3. In a new PowerShell/Terminal window, launch another shell connected to the container:
 
```
    docker exec -it ares-docker_game_1 /bin/bash -l
```

5. In the **second docker shell**, start the web portal:

```
    cd ares-webportal
    npm install --no-audit --no-fund
    ember serve
```

You should now be able to connect to your game on localhost:4201 and connect to the web portal at http://localhost:4200.

> Note: If you have trouble connecting, try setting the `bind_address` field in `server.yml` to "0.0.0.0" and then restart the game.

# Database

Your database will be saved in `data/dump.rdb`.

The database saves every few minutes. If you want to ensure it's saved before stopping the container, just use the `db/save` command.