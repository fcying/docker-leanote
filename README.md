
# Docker Image for Leanote

## docker-compose.yml

Edit this `docker-compose.yml`
```
version: '3' 
services:
    leanote:
        image: fcying/leanote:latest
        restart: always
        environment:
            - AUTO_BACKUP=1     # auto backup data
            - KEEP_DAYS=30      # days of history to keep
        volumes:
            - /etc/localtime:/etc/localtime:ro
            - ./data:/leanote/data
            - ./leanote_backup:/leanote/backup
        ports:
            - "9000:9000"
```



## app.conf  

Modify `port` `url` `mongodb` `secret` config in app.conf

Download app.conf from [Here](https://raw.githubusercontent.com/leanote/leanote/master/conf/app.conf).

move `app.conf` to the `data` folder in the current directory

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
tar xzvf leanote_backup/leanote_xxxx.tgz -Cdata
docker-compose up -d
```



## Auto backup

default backup at `2:00` everday.

you can modify it in `data/crontab`

