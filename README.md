# Projecte_DAM

## Repositori on s'allotja el projecte final de DAM, una aplicació per a gestionar un troneig esportiu.

Per poder posar en funcionament l'aplicació, és proporciona tot el necessari per a que amb l'us de docker, l'usuari puga alçar un servei on poder utilitzar un navegador web i axí consumir l'aplicació.

### PORTS PELS QUE S'ESCOLTARÀ ELS DIFERENTS SERVEIS

- Base de dades: 3307
- Api desenvolupada amb Spring: 9090
- Client web desenvolupat amb flutter: 8080

> [!NOTE]
> Els port de la base de dades i de la Api es poden modificar al fitxer .env del projecte. I el de la web, directament al docker-compose.yml

### EXECUCIÓ DELS CONTENIDORS

Per poder desplegar l'aplicació es tan senzill com executar la següent instrucció a la terminal del sistema operatiu:

`docker-compose up`

> [!WARNING]
> La primera vegada donarà error amb la connexió de la Api a la BD, degut a les dades es carreguen després de muntar els contenidors. Per tant hem de parar els contenidors i tornar a executar `docker-compose up`.

### DOCUMENTACIÓ DE LA API

Un cop tot llançat i en funcionament, podem accedir a la documentació de la Api amb el següent enllaç:

<http://localhost:9090/swagger-ui/index.html>

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

### US DE L'APLICACIÓ CLIENT

Finalment per accedir al lloc web que hem creat, tan sols hem d'accedir al següent enllaç:

<http://localhost:8080>
