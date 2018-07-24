
# Docker Image for Leanote

## docker-compose.yml

Edit this `docker-compose.yml`
```
version: '3' 
services:
    mongo:
        image: mongo:3.4
        restart: always
        volumes:
            - ./leanote-data/db:/data/db

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



## Setup  

Update mongo config in app.conf

Download app.conf from [Here](https://raw.githubusercontent.com/leanote/leanote/master/conf/app.conf).

Then update mongo section:

```
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



