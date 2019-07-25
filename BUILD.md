開発環境構築手順 on Docker
===============

# first build
```
$ docker-compose build
$ docker-compose run web db:create
$ docker-compose run web db:migrate
$ docker-compose run web arcana:import
$ docker-compose run web yarn install
```

# import arcana masters
```
$ docker-compose run web arcana:import
```

# update gems
```
$ docker-compose build --no-cache
```

# update js-lib
```
$ docker-compose run web yarn install
```

# start containers
```
$ docker-compose up
```
