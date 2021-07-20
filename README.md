These are instructions for using the [Docker](https://www.docker.com) container to run an [AresMUSH](https://aresmush.com) development environment on your local PC/Mac.

> **Note:** This setup is only intended for local development only, and is **not** suitable for a real production game.

## Initial Setup

To set up the container for the first time:

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop).

2. Clone this repo to your local PC/Mac.

3. In the working directory for the ares-docker repo, clone the aresmush and ares-webportal code repos. Your directory should now look like this:
  
```
    ares-docker
      - aresmush
      - ares-webportal
      - data
```

4. Copy the `aresmush/install/game.distr` directory to create a new folder `aresmush/game`.

5. From the ares-docker directory, start the container:

```   
    docker-compose up
```

6. Launch a shell connected to the container:
 
```
     docker exec -it ares-docker_game_1 /bin/bash -l
```

7. Within the shell, run these commands to set up the game:
 
```
    cd aresmush
    bin/configure
      - Use 127.0.0.1 for the host
      - Use default ports (this setup will not work with different ports)
      - Ignore the warning about the web portal directory not being found - that's OK.
    bin/wipedb
```

## Running the Game

After initial setup, here are the commands you'll want to use whenever you want to run the game.

> Note: If you still have the ares container running from the initial setup, you can skip step 1.

1. Start the container and database:
 
```
    docker-compose up
```

2. Launch a shell connected to the container and start the game:
 
```
    docker exec -it ares-docker_game_1 /bin/bash -l
    cd aresmush
    bin/devstart
```

3. Launch another shell and start the web portal:
 
```
    docker exec -it ares-docker_game_1 /bin/bash -l
    cd ares-webportal
    bin/devportal
```

You should now be able to connect to your game on localhost:4201 and connect to the web portal at http://localhost:4200.

> Note: If you have trouble connecting, try setting the `bind_address` field in `server.yml` to "0.0.0.0" and then restart the game.

# Database

Your database will be saved in `data/dump.rdb`.

The database saves every few minutes. If you want to ensure it's saved before stopping the container, just use the `db/save` command.