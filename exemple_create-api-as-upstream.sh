#!/bin/bash

######################################
#V A R S

## INICIO
#IP do servidor KONG
KONG_IP=192.168.0.10

#Endereços IP dos targets para balanceamento
TARGET_LB="
192.168.0.100
192.168.0.101"

#Porta de comunicação do target
TARGET_PORT=30004

#Path para acesso via API Gateway
PATH_URI="/fastapi"

#Nome da API
SVC_NAME="fastApi"

## FIM
#######################################


clear
echo "_________________________________________________________________________"
#Testa se as variaveis foram "setadas"
if [ -z $KONG_IP ] || [ -z "$TARGET_LB" ] || [ -z $TARGET_PORT ] || [ -z $PATH_URI ] || [ -z $SVC_NAME ] ; then
clear
echo -e "
[-] Adicione valores nas variaveis corretamente !!!

Valores configurados:

\n KONG_IP = $KONG_IP
\n TARGET_LB = $TARGET_LB
\n TARGET_PORT = $TARGET_PORT
\n PATH_URI = $PATH_URI
\n SVC_NAME = $SVC_NAME
"
fi

#testa se a API do kong esta acessivel
echo
TESTE=`curl -s --connect-timeout 1 $KONG_IP:8001`
if [ $? -ne 0 ] ; then
  echo
  echo -e "\n[-] Falha ao conectar na API $KONG_IP:8001"
  exit 1
else
 echo
 echo -e "\n[+] Conexão com a API do Kong $KONG_IP:8001 - OK"
fi
sleep 2
echo
echo "_______________________________________________________________________"
echo "[+] Criando Upstream lb-$SVC_NAME.."
#Cria upstream (LB)
curl -s -X POST  http://$KONG_IP:8001/upstreams  --data name=lb-$SVC_NAME

echo
echo "_______________________________________________________________________"
echo "[+] Criando targets..."
#Cria targets
for target in `echo $TARGET_LB`
do
  echo "  > target: $targeti:$TARGET_PORT"
  curl -s -X POST http://$KONG_IP:8001/upstreams/lb-$SVC_NAME/targets --data target="$target:$TARGET_PORT" --data "weight=100"
done


#Cria o service baseado no LB
echo "______________________________________________________________________"
echo "[+] Criando service apontando svc-$SVC_NAME"
curl -s -X POST http://$KONG_IP:8001/services  --data host=lb-$SVC_NAME  --data name=svc-$SVC_NAME  --data path=/  --data port=$TARGET_PORT

echo
echo "______________________________________________________________________"
echo "[+]Criando rota route-$SVC_NAME"
#Cria a rota para o serviço:
curl -s  -X POST http://$KONG_IP:8001/services/svc-$SVC_NAME/routes   --data paths=$PATH_URI  --data name=route-$SVC_NAME --data methods=GET --data methods=POST --data methods=OPTIONS --data methods=PATCH --data methods=DELETE

#Teste de acesso

echo
echo "______________________________________________________________________"
echo "[+] Testando acesso via API Gateway em http://$KONG_IP$PATH_URI"

curl -s -X GET $KONG_IP$PATH_URI

if [ $? -ne 0 ] ; then
  echo
  echo
  echo "  [-] Falha ao publicar a API"
else
  echo
  echo
  echo "  [+] API  http://$KONG_IP$PATH_URI publicada com sucesso!!!"
  echo "______________________________________________________________________"
fi

echo

