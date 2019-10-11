
# Docker Image for Leanote

## docker-compose.yml

Edit this `docker-compose.yml`
```
version: '2' 
services:
    leanote:
        image: fcying/leanote:latest
        environment:
            - PUID=1000
            - PGID=1000
            - UMASK_SET=022
            - AUTO_BACKUP=1     # auto backup data
            - BACKUP_HOUR=2     # auto backup time
            - KEEP_DAYS=30      # days of history to keep
        volumes:
            - /etc/localtime:/etc/localtime:ro
            - ./data:/leanote/data
            - ./leanote_backup:/leanote/backup
        ports:
            - "9000:9000"
        restart: always
```



## app.conf  

Modify `port` `url` `mongodb` `secret` config in app.conf. 

Download app.conf from [Here](https://raw.githubusercontent.com/leanote/leanote/master/conf/app.conf).

move `app.conf` to the `data` folder in the current directory.

If there is no such file, will be automatically generated a default app.conf.

Then modify section:

```
http.port=9000
site.url=http://localhost:9000 # or http://x.com:8080, http://www.xx.com:9000

# mongdb
db.host=127.0.0.1
db.port=27017
db.dbname=leanote # required
db.username= # if not exists, please leave it blank
db.password= # if not exists, please leave it blank
# or you can set the mongodb url for more complex needs the format is:
# mongodb://myuser:mypass@localhost:40001,otherhost:40001/mydb
# db.url=mongodb://root:root123@localhost:27017/leanote
# db.urlEnv=${MONGODB_URL} # set url from env. eg. mongodb://root:root123@localhost:27017/leanote

# You Must Change It !! About Security!!
app.secret=V85ZzBeTnzpsHyjQX4zukbQ8qqtju9y2aDM55VWxAH9Qop19poekx3xkcDVvrD0y #
```



## Run
```
docker-compose up -d
```



## Stop
```
docker-compose down
```



## Backup
```
docker-compose exec leanote /init backup
```



## Restore
```
docker-compose down
rm -rf ./data && mkdir data
tar -Cdata -xzvf leanote_backup/leanote_xxxx.tgz
docker-compose up -d
```



## Auto backup

default backup at `2:00` everday.

`AUTO_BACKUP`:    1:enable; 0:disable
`BACKUP_HOUR`:    backup hour

