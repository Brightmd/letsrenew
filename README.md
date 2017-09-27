# letsrenew

A simple docker container that automatically runs `certbot renew` periodically.
Stands in for a cron job, with less maintenance and no permission or
environment issues to worry about, such as would normally accompany a cron
job.

`letsrenew` can use AWS Route53 for answering challenges. You must have an
AWS account configured to make the appropriate changes. A section of this
document details the permissions you will need.


### Use, Initial cert creation:

Run the letsrenew image, using a `-v` volume mount to overlay
`/etc/letsencrypt` using the hosts's directory.

You also specify some environment variables to acquire AWS credentials for the
dns-route53 plugin, and specify `certonly_domain` to tell the container to
acquire the cert for the new domain and then immediately quit.

```
# To use this option, you must have AWS credentials set up as well, with a
# policy to allow changes to resource records. See below for an example
# policy.
certbot_flags='--dns-route53,-mYOUREMAIL@IDK.COM,--agree-tos'

docker run \
    -e certonly_domain=yourhost.yourzone.com \
    -e certbot_flags=$certbot_flags \
    -e AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) \
    -e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) \
    -v /etc/letsencrypt:/etc/letsencrypt \
    brightmd/letsrenew:0.3
```

*If you are using Docker for Mac, replace `-v
/etc/letsencrypt:/etc/letsencrypt` with: `-v
/private/etc/letsencrypt:/etc/letsencrypt`*


### Use, Renewal:

This container stays running in the background, checking for renewals
periodically.

It also uses `--restart always` to ensure that the job survives a reboot or
engine restart.


```
certbot_flags='--dns-route53'

docker run \
    -d \
    --restart=always \
    -e AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) \
    -e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) \
    -e certbot_flags=$certbot_flags \
    -v /etc/letsencrypt:/etc/letsencrypt \
    brightmd/letsrenew:0.3
```

### AWS Route53 Policy example
```
{
  "Version": "2012-10-17",
  "Id": "certbot-dns-route53 sample policy",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [ "route53:ListHostedZones", "route53:GetChange" ],
      "Resource": [ "*" ]
    },
    {
      "Effect": "Allow",
      "Action": [ "route53:ChangeResourceRecordSets" ],
      "Resource": [ "arn:aws:route53:::hostedzone/YOURHOSTEDZONEID" ]
    }
  ]
}
```



## Release Notes

* 0.3: (2017-09-28) parse multiple comma-separated certbot args
* 0.2: (2017-06-26) switch to certbot-dns-route53
* 0.1: use corydodt/circus-base:0.1
