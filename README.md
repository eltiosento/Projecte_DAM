# Projecte_DAM

## Repositori on s'allotja el projecte final de DAM, una aplicació per a gestionar un troneig esportiu.

Aquest enllaç mostra l'aplicació web totalment desplegada a AWS:

 - <http://torneig-client.s3-website.eu-south-2.amazonaws.com>

Per poder posar en funcionament l'aplicació, és proporciona tot el necessari per a que amb l'us de docker, l'usuari puga alçar un servei on poder utilitzar un navegador web i axí consumir l'aplicació.

### PORTS PELS QUE S'ESCOLTARÀ ELS DIFERENTS SERVEIS

- Base de dades: 3307
- Api desenvolupada amb Spring: 9090
- Client web desenvolupat amb flutter: 8080

> [!NOTE]
> Els ports de la base de dades i de la Api es poden modificar al fitxer .env del projecte. I el de la web, directament al docker-compose.yml

### COMPILAR L'APLICACIÓ WEB PER A QUE PUGA CONECTAR AMB LA API

L’aplicació client, desenvolupada en Flutter, ha de ser compilada i configurada per connectar-se correctament amb l’API. Els passos són els següents:
 1. **Instal·lació de dependències**:
     -	Executa la comanda següent al directori del client per descarregar totes les dependències necessàries:
     
    `flutter pub get`.

2.	**Configuració de l’IP del Servidor**:
    - Accedeix al fitxer *app_torneig_flutter/lib/conf/ip.dart* i substitueix la variable IP per l’adreça IP real del servidor on s’executarà l’API:


```dart
class Ip {
  static const IP = "<<ip>>:9090";
}
```
  - Exemple per a un entorn local:
  
```dart
class Ip {
  static const IP = "192.168.1.100:9090";
}
```

- Exemple per a un entorn de producció amb AWS:
  
```dart
class Ip {
  static const IP = "18.101.94.248:9090"; // AWS API
}
```
3.	**Construcció de l’Aplicació Web:**
     - Un cop configurada l’IP, compila l’aplicació per generar els fitxers necessaris:
`flutter build web`

    - Els fitxers es generaran a la carpeta build/web/.



Així que finalment, per accedir al lloc web que hem creat, tan sols hem d'accedir al següent enllaç:

<http://localhost:8080>

O per altra banda a altres dispositius a la mateixa xarxa: <http://ipPcOnEstaTotMuntat:8080>

A més de la versió web, s’ha creat una aplicació Android per a ús mòbil. Aquesta aplicació es pot instal·lar en qualsevol dispositiu amb Android.
Està dissenyada de forma responsiva per adaptar-se a diferents pantalles.
Per defecte, està configurada per connectar-se a l’API de AWS, la qual cosa permet utilitzar-la des de qualsevol lloc fora de l’entorn local.
________________________________________



### EXECUCIÓ DELS CONTENIDORS

Un cop contruida l'aplicació web, ja podem crear els contenidors per a muntar l'entorn local. 
Per poder desplegar l'aplicació es tan senzill com desde el directori l'arrel on es troba el fitxer docker-compose, executar la següent instrucció a la terminal del sistema operatiu:

`docker-compose up`

> [!WARNING]
> La primera vegada donarà error amb la connexió de la Api a la BD, degut a les dades es carreguen després de muntar els contenidors. Per tant hem de parar els contenidors i tornar a executar `docker-compose up`.

### DOCUMENTACIÓ DE LA API

Un cop tot llançat i en funcionament, podem accedir a la documentació de la Api amb el següent enllaç:

<http://localhost:9090/swagger-ui/index.html>

> [!NOTE]
> Com que també està la api desplegada en AWS es pot accedir amb aquest enllaç:
> *http://18.101.94.248/swagger-ui/index.html*
> Si no funciona comunicameu per a que renicie el servidor, ja que de vegades es cau. (Desconec el motiu)

Degut a que la Api utilitza un sistema d'autenticació mitjançant JWT, hem d'hanar a l'apartat de ***Controlador d'usuaris Api*** i allí polsar sobre ***POST /api/auh/login***
donar-li al botó ***Try it out*** i introduir les credencials per a que ens proporcione un token que utilitzarem per a l'autenticació.

```Json
{
  "username": "string",
  "password": "string"
}
```

Usuaris predefinits:

- Usuari administrador: `admin` i contrasenya `admin`.
- Usuari corrent: `alu` i contrasenya `alu`.

> [!NOTE]
> Aquests usuaris també els hem de servir per fer el login a l'aplicació del client.

Al executar, ens donarà a la resposta un token que hem de copiar i pegar al botó ***Authorize*** del principi de la pàgina.

```Json
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhbHUiLCJpYXQiOjE3MzA4MDkwOTAsImV4cCI6MTczMDg5NTQ5MCwicm9sZXMiOlsiVVNFUiJdfQ.wSES7J_GSuXmuoktncE6rhOZbVoGV_zPLdfJyV8I0Mak04dkBNun52qMp-b_FLWxpoo7cRqLdehPMG9UPXTJYA",
  "type": "Bearer",
  "id": 2,
  "username": "alu",
  "roles": [
    "USER"
  ]
}
```

### DIRECTORIS DEL PROJECTE

Así indique cada directori que conté:

- **BD**
  - Conté un fitxer .sql per ejecutar l'escript i muntar les taules i les dades a la base de dades.
  
- **Torneig_Mort_Spring**
  - Aquest directori conté tot el codi i treball realitzat amb Spring per desenvolupar la Api.

- **app_torneig_flutter**
  - Aquest directori trobem tot el treball fet amb flutter per desenvolupar el client.