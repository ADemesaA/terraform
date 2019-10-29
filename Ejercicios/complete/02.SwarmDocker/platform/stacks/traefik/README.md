## Agregando variables de entorno

```bash

export DOMAIN=chakray.com
export USERNAME=admin
export PASSWORD=changethis
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)
export TRAEFIK_REPLICAS=1
```
## Generar certificados

```bash

sh ./certificados/generate_wildcard.sh
```

## Crear red para Traefik y contenedores accesibles desde fuera del swarm
```bash
docker network create --driver=overlay traefik --subnet=192.168.1.0/24
```

### Desplegar

```bash
docker config create traefik-crt configs/traefik.crt
docker config create traefik-key configs/traefik.key
docker config create traefik-conf configs/traefik.toml

docker stack deploy -c traefik.yml traefik
```

### Verificar

```bash

docker stack ps traefik
docker service logs traefik_traefik
```
https://traefik.<your domain>
https://consul.<your domain>
