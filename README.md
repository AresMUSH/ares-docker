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

5. In a Windows PowerShell or Mac Terminal window, start the container:

```   
    cd YOUR_ARES_DOCKER_DIRECTORY
    docker-compose up
```

6. In a **new** PowerShell/Terminal window, use this command to launch a shell connected to the container:
 
```
     docker exec -it ares-docker_game_1 /bin/bash -l
```

7. Within the **docker shell** you just launched, run these commands to set up the game:
 
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

1. In a Windows PowerShell or Mac Terminal window, start the container:
 
```
    cd YOUR_ARES_DOCKER_DIRECTORY
    docker-compose up
```

2. In a **new** PowerShell/Terminal window, launch a shell connected to the container:

```
    docker exec -it ares-docker_game_1 /bin/bash -l
```

3.  Within the **docker shell** you just launched, run these commands to start the game:
 
```
    cd aresmush
    bundle install
    bundle exec rake startares[disableproxy]
```

3. In a **new** PowerShell/Terminal window, launch another shell connected to the container:
 
```
    docker exec -it ares-docker_game_1 /bin/bash -l
```

5. In the **second docker shell** you just launched, start the web portal:

```
    cd ares-webportal
    npm install --no-audit --no-fund
    ember serve
```

You should now be able to connect to your game on localhost:4201 and connect to the web portal at http://localhost:4200.

> **Note:** If you have trouble connecting, try setting the `bind_address` field in `server.yml` to "0.0.0.0" and then restart the game.

# Reloading Code

Any code changes you make in the aresmush and ares-webportal directories under your ares-docker folder **should** be automatically seen by the docker container.

```
    ares-docker
      - aresmush   <<---  make game changes here 
      - ares-webportal <<---  make web portal changes here 
      - data
```

That should trigger a live-reload of the dev portal, and be picked up if you do `load <plugin>` from your MUSH client.
  
Sometimes permissions issues can mess up this automatic code mirroring. If this happens to you:

1. Make sure you've got the latest version of Docker Desktop.
2. If on Widows, be sure you installed the Windows Subsystem for Linux. Docker probably prompted you for this when you installed it or started a container. If not, try the [Microsoft instructions](https://docs.microsoft.com/en-us/windows/wsl/install).
3. You may try some of the options described in [Docker for Windows Best Practices](https://docs.docker.com/desktop/windows/wsl/), though they can require some fiddling.
4. If all else fails, restarting the container will refresh the code.

# Database

Your database will be saved in `data/dump.rdb`.

The database saves every few minutes. If you want to ensure it's saved before stopping the container, just use the `db/save` command.