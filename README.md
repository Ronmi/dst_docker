# DST in docker

Create your own Don't Starve Together dedicated server in seconds!

See wiki pages on github for detailed usage.

## Requirement
- sudo (optional)
- bash
- docker

## Synopsis

```sh
dst.sh install # run once only
```

```sh
mkdir servers/myserver
gedit servers/myserver/settings.ini
cp some_where_else servers/myserver/server_token.txt
gedit servers/myserver/dedicated_server_mods_setup.lua servers/myserver/modoverrides.lua #optional
dst.sh create myserver
dst.sh start myserver
```

## dst.sh

`dst.sh` is the main program of this project.

- `dst.sh create dirname`: create container
- `dst.sh start dirname`: start server
- `dst.sh stop dirname`: stop server
- `dst.sh restart dirname`: identical to `dst.sh stop subdir ; dst.sh start subdir`
- `dst.sh reset dirname`: stop the server, `rm -fr servers/subdir/save` then start the server
- `dst.sh update`: update DST server software

## Sharding

`dst.sh` supports sharding after 0.5.

For master, `bind_ip` MUST set to `0.0.0.0`.

For slave, you should use `dst_SERVERNAME` as `master_ip`, and add a special setting `master_link = true` in your `settings.ini`.

See `example/` for example.

## License

GPLv1 or newer version.
