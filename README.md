
# Docker Image for Leanote

## docker-compose.yml

Edit this `docker-compose.yml`
```
version: '3' 
services:
    mongo:
        image: mongo:3.6
        restart: always
        volumes:
            - /etc/localtime:/etc/localtime:ro
            - ./leanote-data/db:/data/db
            - ./leanote-data/configdb:/data/configdb

    leanote:
        image: fcying/leanote:latest
        restart: always
        links:
            - mongo:db
        volumes:
            - ./app.conf:/leanote/app.conf
            - ./leanote-data:/leanote/data
        ports:
            - "9000:9000"
```



## app.conf  

Modify `port` `url` `mongo` `secret` config in app.conf

Download app.conf from [Here](https://raw.githubusercontent.com/leanote/leanote/master/conf/app.conf).

Then modify section:

```
http.port=9000
site.url=http://localhost:9000 # or http://x.com:8080, http://www.xx.com:9000

# mongdb
db.host=db
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



## Shell
```
docker-compose run --rm leanote bash
```



