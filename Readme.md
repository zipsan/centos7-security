# CentOS 7 Security Repository docker

This docker-compose.yml create a security repository for CentOS 7.

CentOS Security Repository is not provided globally. So some of yum commands for security is not work, for example,

* `yum --security update`
* `yum-cron` ('security', 'security-minimal')

# Install

```
docker-compose up
```

and access to `[docker-server-ip]:8080`.

By default, crond running background update your security repository at 0:00AM every day.

If you want to change this schedule, you should rewrite `crontab` and run `docker-compose up --force-recreate --build`.


