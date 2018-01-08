docker run -d --name blog -p 80:80 -p 8388:8388 297951292/blog nginx
hasCrontab=$(crontab -l | grep "/home/johnny/github-auto-updater/backup-blog.sh")

if [ ! $hasCrontab ]; then
    echo "0 0 * * * /home/johnny/github-auto-updater/backup-blog.sh >> /home/johnny/backup-blog.log" | crontab -
fi
