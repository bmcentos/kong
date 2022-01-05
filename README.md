Instalation of KONG + POSTGRES + KONGA

-Download of docker-compose

#sudo curl -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 

#sudo chmod +x /usr/local/bin/docker-compose

-Download of compose file:

#git clone https://github.com/bmcentos/kong.git && cd kong

or

#wget https://raw.githubusercontent.com/bmcentos/kong/main/docker-compose.yml

#docker-compose up -d

Wait for 5 to 10 minutes, until all stay up

-Access KONGA: http://$IP:8080


![image](https://user-images.githubusercontent.com/25855270/115333532-34d95700-a170-11eb-96c5-f6c23ae45006.png)

-Access root route http: http://$IP


![image](https://user-images.githubusercontent.com/25855270/115333692-7cf87980-a170-11eb-941a-21bc34c8ca24.png)

-Access root route https: http://$IP:443

	OBS: If you using SSL, create the directory .ssl and put key and pem file in it
	mkdir .ssl
	cp ssl.pem ssl.key .ssl/
	-uncomment the volume from kong service in docker-compose and the environments about ssl keys

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


----------

Test FastAPI 

#cd fastApi/

#docker build -t fastapi .

#docker run --network kong_kong-net -d --name fastapi -p 8081:80 fastapi

-Add service in Konga pointing to fastapi created
![image](https://user-images.githubusercontent.com/25855270/148257301-7dfaf5b3-d999-4ec9-a73d-dfe8683c2801.png)

- Create route /app

![image](https://user-images.githubusercontent.com/25855270/148257435-085a5ced-146e-4154-81f9-aa55a4d28897.png)


-Test access:

- endpoint /
#curl -X GET  http://$IP/app

- endpoint /teste
#curl -X GET  http://$IP/app/teste

- endpoint items/[num]
#curl -X GET  http://$IP/app/items/1

So after that you can test plungins and consumers functionality



