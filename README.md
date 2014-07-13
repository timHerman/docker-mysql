#docker-mysql
Dedicated mysql container created for easy database setup with eye on web applications
 
## About

This container is optimized for fast and easy created of databases
Watch it in action using at github ( https://github.com/timHerman/docker-nginx-wordpress )
or at docker ( https://registry.hub.docker.com/u/timherman/nginx-wordpress/ )

## Usage by example

### The mysql container

#### Running the container

```shell
docker run -d --name="be.punk.www.mysql" -e "MYSQL_LOCAL_USER=[username]" -e "MYSQL_LOCAL_DATABASE=[database]" -e "MYSQL_LOCAL_PASSWORD=[password]" -v /location/of/mysqldata/at/host/:/var/lib/mysql/  timherman/mysql
```

#### How it works

* -d : Run daemonized
* --Name : The name of the container
* -e : Environmental parameters
  * MYSQL_ROOT_PASSWORD : When no root password of the database is generated there will be one generated for you
  * MYSQL_LOCAL_USER : The mysql username for your application
  * MYSQL_LOCAL_DATABASE : The mysql database name for your application
  * MYSQL_LOCAL_PASSWORD : The mysql database password
* -v : Linking a directory on your host with the mysql data of the container
* timherman/mysql : The name of the repository	

## Comments

For more information leave a message or visit http://www.punk.be

Regards,
Tim
