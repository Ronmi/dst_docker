# DST in docker

Create your own Don't Starve Together dedicated server in seconds!

## Requirement
- sudo
- debootstrap
- bash
- docker
- knowing how to setup dedicated_server_mod_setup.lua and file structure of ~/klei
- knowing how to use debootstrap

## Preparing the system

First, make base system image.

```sh
make-baseimage.sh debian_mirror_for_debootstrap suit_for_debootstrap
```

Then edit dst/dedicated_server_mod_setup.lua if you want to enable mods in your server.

After that, you can build the main docker image with `build-dstserver.sh`.

Now you have a base image to run dst in docker.

## Create a server

First, create a subdir in servers and put the settings.ini/server_token.txt in it.

Run `dst.sh create subdir_name` to create docker container. It will set the port mapping according to your settings.ini.

Run `dst.sh start subdir_name` to start your server and enjoy it.

You can create several servers if your hosting service provider/PC can handle it.

## Update your server to the most recent version

`dst.sh update` will update dst server software and recreate all containers.

## dst.sh

`dst.sh` is the main program of this project.

- `dst.sh create subdir`: create container
- `dst.sh start subdir`: start server
- `dst.sh stop subdir`: stop server
- `dst.sh restart subdir`: identical to `dst.sh stop subdir ; dst.sh start subdir`
- `dst.sh reset subdir`: stop the server, `rm -fr servers/subdir/save` then start the server
- `dst.sh update`: update DST server software

## License

GPLv1 or newer version.
