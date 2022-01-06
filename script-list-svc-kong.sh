#!/bin/bash
# Author: Bruno Miquelini
# Create a simple html page index to list Services, Routes, Paths and plugins configured in Kong Api


#Add API Address of Kong
KONG_IP=192.168.0.100

#Add url of favicon.ico
URL_FAV=   #EX https://site.com/favicon.ico

#ADICIONA HEADER
echo "<head>"
echo "  <title>Serviços Kong></title>"
echo "  <link href="https://unpkg.com/mvp.css" rel="stylesheet"></link>"
echo "  <link rel="icon" type="image/x-icon" href="$URL_FAV"></link>"

echo "</head>"
echo

#CRIA HEADER DA TABELA
echo "<center>"
echo "<tittle><h1>Serviços Kong</h1></tittle>"
echo "<table border="2">"
echo "  <tr>"
echo "          <td><strong><a>Serviço</a></td>"
echo "          <td><strong><a>Rota</a></td>"
echo "          <td><strong><a>Path</a></td>"
echo "          <td><strong><a>Plugin Service</a></td>"
echo "          <td><strong><a>Plugin Rota</a></td>"
echo "  </tr>"
echo

#CRIA CONTEUDO DA TABELA
svcs=`curl -s $KONG_IP:8001/services| tr ',' '\n'| grep name | cut -d ":" -f2  | tr -d "\""`
for i in $svcs
 do
  echo "        <tr>"
  rota=`curl -s $KONG_IP:8001/services/$i/routes| tr ',' '\n'| grep "\"name" | cut -d ":" -f3 | tr -d '"'`
  p_svcs=`curl -s $KONG_IP:8001/services/$i/plugins| tr , '\n'| grep "\"name"| cut -d ":" -f3`
  path=`curl -s $KONG_IP:8001/services/$i/routes | tr "," '\n' | grep "paths"| cut -d ":" -f2`

  p_route=`curl $KONG_IP:8001/routes/$rota/plugins | tr ',' '\n'| grep "\"name" | cut -d ":" -f2 | tr -d '"'|grep -v \{name`
  echo "                <td> $i </td> "
  echo "                <td>$rota </td>"
  echo "                <td>$path </td>"
  echo "                <td>$p_svcs </td>"
  echo "                <td>$p_route </td>"
  echo "        </tr>"
 done

n_svcs=`curl -s $KONG_IP:8001/services| tr ',' '\n'| grep name | cut -d ":" -f2  | tr -d "\"" | wc -l`
echo "<h3> Nº serviços: $n_svcs</h3>"

echo "</center>"


#Caso utilize em cron, adicionar na crontab:
#*/2 * * * * /root/listaRotas.sh 2> /dev/null >/var/www/html/index.html

#Se utilizar na cron, descomente as linhas abaixo
#chown -R apache /var/www/html/
#chmod 110 /var/www/html/css
