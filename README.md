# docker-shadowsocks-libev-obfs-privoxy
dockerfile of shadowsocks-libev with simple-obfs and privoxy

## Usage

### Build
```
git clone https://github.com/ZRStea/docker-shadowsocks-libev-obfs-privoxy.git
docker build ./docker-shadowsocks-libev-obfs-privoxy -t docker-shadowsocks-libev-obfs-privoxy
```

### example:


ss-local with simple-obfs and privoxy:

```
docker run -p 127.0.0.1:1080:1080/tcp -p 127.0.0.1:1080:1080/udp -p 127.0.0.1:8118:8118/tcp \
docker-shadowsocks-libev-obfs-privoxy sh -c "privoxy /etc/privoxy/config && \
ss-local -s YourServerIP -p YourServerPort -l 1080 -m CipherMode -k YourPassword -u -b 0.0.0.0 \
--plugin obfs-local --plugin-opts "obfs=http;obfs-host=www.cloudflare.org""
```

ss-server with simple-obfs:

```
docker run -p 80:80/tcp -p 80:80/udp \
docker-shadowsocks-libev-obfs-privoxy ss-server \
-k Password -m CipherMode -p 80 -u --plugin obfs-server --plugin-opts "obfs=http"
```

If you wanna container restart automatically, using `--restart=always`
