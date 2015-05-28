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
Running it without arguments will use `ftp.debian.org` as mirror and stable (jessie) as suit.
It is suggested to use local mirror for faster download speed, you can find it on [Debian mirror list](https://www.debian.org/mirror/list)

Then edit `dst/dedicated_server_mod_setup.lua` if you want to enable mods in your server.

After that, you can build the main docker image with `build-dstserver.sh`.

Now you have a base image to run dst in docker.

## Create a server

First, create a subdir in servers and put the settings.ini/server_token.txt in it.

Run `dst.sh create subdir_name` to create docker container. It will set the port mapping according to your settings.ini.

Run `dst.sh start subdir_name` to start your server and enjoy it.

You can create several servers if your hosting service provider/PC can handle it.

## Update your server to the most recent version

`dst.sh update` will update dst server software and recreate all containers.

## Example

Here's what I did when creating two DST server on linode.

#### Prepare the system
Upload token
```sh
scp ~/.klei/DoNotStarveTogether/server_token.txt ronmi@linode:.
```
Login to linode
```sh
ssh ronmi@linode
```
Download dst_docker
```sh
git clone https://github.com/Ronmi/dst_docker.git ~/dst
```
Get into it
```sh
cd dst
```
Build base system image using linode provided local mirror
```sh
./make-baseimage.sh http://mirrors.linode.com/debian
```
Enable mods
```sh
vi dst/dedicated_server_mod_setup.lua
```
Really build the image
```sh
./build-dstserver.sh
```

#### Create first server
Create folder
```sh
mkdir servers/ronmi
```
Preparing essential files
```sh
vi servers/ronmi/settings.ini
vi servers/ronmi/modoverrides.lua
vi servers/ronmi/worldgenoverride.lua
cp ~/server_token.txt servers/ronmi/
```
Create docker container
```sh
./dst.sh create ronmi
```
Start server
```sh
./dst.sh start ronmi
```

#### Create another server
Create folder
```sh
mkdir servers/bva
```
Preparing essential files
```sh
vi servers/bva/settings.ini
cp ~/server_token.txt servers/ronmi/
```
Create docker container
```sh
./dst.sh create bva
```
Start server
```sh
./dst.sh start bva
```


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
