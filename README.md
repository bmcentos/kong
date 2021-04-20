From: https://github.com/Kong/docker-kong/tree/master/compose

Add kong password:
#echo "kong" > POSTGRES_PASSWORD

#sudo curl -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 

#sudo chmod +x /usr/local/bin/docker-compose

#docker-compose up -d

######################
Securing API Admin as Service:

#curl -X POST http://localhost:8001/services \
  --data name=admin-api \
  --data host=localhost \
  --data port=8001
  
  #curl -X POST http://localhost:8001/services/admin-api/routes \
  --data paths\[\]=/admin-api
  
  #curl -X POST http://localhost:8001/services/admin-api/plugins \
	    --data "name=basic-auth"  \
	    --data "config.hide_credentials=true"

#curl -d "username=admin&custom_id=1" http://localhost:8001/consumers/

#curl -X POST http://localhost:8001/consumers/admin/basic-auth     --data "username=admin"     --data "password=admin"

-Use base64 credentials:
# echo "admin:admin" |base64

#curl -s -X GET   --url http://localhost:80/admin-api  --header 'Authorization: Basic YWRtaW46YWRtaW4K'
