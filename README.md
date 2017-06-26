# letsrenew

A simple docker container that automatically runs `certbot renew` periodically.
Stands in for a cron job, with less maintenance and no permission or
environment issues to worry about, such as would normally accompany a cron
job.

`letsrenew` relies on AWS Route53 for answering challenges. You must have an
AWS account configured to make the appropriate changes. A section of this
document details the permissions you will need.


### Use:

#### Before running, you should have already set up a LetsEncrypt certificate with certbot. This tool does not provision the initial certificate.

Run the letsrenew image, using a `-v` volume mount to overlay
`/etc/letsencrypt` using the hosts's directory.

This also uses `--restart always` to ensure that the job survives a reboot or
engine restart.

#### You should have AWS credentials set up as well, with a policy to allow changes to resource records. See below for an example policy.


```
host_letsencrypt=/etc/letsencrypt

docker run \
    -d \
    --restart=always \
    -e AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) \
    -e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) \
    -v ${host_letsencrypt}:/etc/letsencrypt \
    brightmd/letsrenew
```

### On a Mac:

If you are using [Docker for Mac](https://docs.docker.com/docker-for-mac/install/) 
run the SAME COMMAND, but change the first line to:

```
host_letsencrypt=/private/etc/letsencrypt
```

### AWS Route53 Policy example
```
Version: 2012-10-17
Id: certbot-dns-route53 sample policy
Statement:
  - Effect: Allow
    Action:
      - route53:ListHostedZones
      - route53:GetChange
    Resource: ["*"]
  - Effect: Allow
    Action:
      - route53:ChangeResourceRecordSets
    Resource:
      - arn:aws:route53:::hostedzone/YOURHOSTEDZONEID
```

TBD: Using conditions to specify more precise control

## Release Notes

* 0.2: (2017-06-26) switch to certbot-dns-route53
* 0.1: use corydodt/circus-base:0.1
