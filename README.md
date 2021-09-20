# open-osp-server
Host bootstrap and jobs, for OpenOSP

## Server Node Bootstrap
You should be the root user when setting up the open osp server
```
git clone https://github.com/open-osp/open-osp-server
cd open-osp-server
./bin/setup.sh
```

### Monitoring

Add to CronTab:

```
00 00     * * *   admin cd /home/admin/open-osp-server && ./bin/system-usage.sh
```

Add /home/admin/.env with

```
SENDGRID_API_KEY=<key here>
```
