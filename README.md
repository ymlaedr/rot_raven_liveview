# rot_raven_liveview

## 初期化
```sh
docker-compose run --rm liveview mix do deps.get, deps.compile \
 && docker \
  run \
  --rm \
  -v ${PWD}/liveview/assets:/root/assets \
  -v ${PWD}/liveview/deps:/root/deps \
  --workdir /root \
  node:12.1-alpine \
    /bin/sh -c "cd ./assets && npm install"
```
