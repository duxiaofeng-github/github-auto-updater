docker login
docker run -d --name blog -p 80:80 -p 13425:13425 297951292/blog nginx

hasCrontab=$(crontab -l | grep "/home/johnny/github-auto-updater/backup-blog.sh")
cron=$'0 0 * * * /home/johnny/github-auto-updater/backup-blog.sh >> /home/johnny/backup-blog.log\n0 0 * * * /home/johnny/github-auto-updater/github-updater.sh >> /home/johnny/github-updater.log'

[ "$hasCrontab"=="" ] && echo "$cron" | crontab -
