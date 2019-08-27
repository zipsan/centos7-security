# CentOS 7 Security Repository docker

This docker-compose.yml create a security repository for CentOS 7.

CentOS Security Repository is not provided globally. So some of yum commands for security is not work, for example,

* `yum --security update`
* `yum-cron` ('security', 'security-minimal')

In order to resolve this problem, create your own security repository and generate `updateinfo.xml` from [CEFS: CentOS Errata for Spacewalk](http://cefs.steve-meier.de/).

This docker-compose.yml create a docker image for centos security repository automatically.

# Install

```
docker-compose up
```

and access to `[docker-server-ip]:8080`.

By default, crond running background update your security repository at 0:00AM every day.

If you want to change this schedule, you should rewrite `crontab` file and run `docker-compose up --force-recreate --build`.

# Configure & Usage

1. Add a security section to the repository setting file.

```bash
$ vim /etc/yum.repos.d/CentOS-Base.repo
[security]
name=CentOS-$releasever - Security
baseurl=http://*******.zipsan.pw/
```

1. Check & Update packages

```bash
$ sudo yum update --security
```

