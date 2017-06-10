# letsrenew

A simple docker container that automatically runs `certbot renew` periodically.
Stands in for a cron job, with less maintenance and no permission or
environment issues to worry about, such as would normally accompany a cron
job.


### Use:

Before running, you should have already set up a LetsEncrypt certificate with
certbot. This tool does not provision the initial certificate.

Run the letsrenew image, using a `-v` volume mount to overlay
`/etc/letsencrypt` using the hosts's directory.

With this configuration, the certificate can be renewed even without an
http-01 challenge.

This also uses `--restart always` to ensure that the job survives a reboot or
engine restart.


```
docker run -d \
    -v /etc/letsencrypt:/etc/letsencrypt \
    --restart always \
    brightmd/letsrenew:latest
```

**On a Mac**:

If you are using [Docker for
Mac](https://docs.docker.com/docker-for-mac/install/) this command should
work instead:


```
docker run -d \
    -v /private/etc/letsencrypt:/etc/letsencrypt \
    --restart always \
    brightmd/letsrenew:latest
```
