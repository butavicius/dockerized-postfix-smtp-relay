Email (posix) config is stripped down version of https://github.com/Tecnativa/docker-postfix-relay

`docker-compose up -d` to start wordpress server


TODO: Make certbot use certonly command if there's no certificates, but renew command afterwards to not hit limit. Entrypoint file maybe
TODO: Make use env file everywhere
TODO: certbot sometimes is too fast and apache is not started yet (refuses connection). Wait few seconds somehow