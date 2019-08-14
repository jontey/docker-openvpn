# OpenVPN-Docker for Mikrotik

## To Start

### On server
```
docker-compose run --rm openvpn ovpn_genconfig -u tcp://{IP_ADDRESS}:{PORT} -d -b -c -a SHA1 -C AES-256-CBC -N -p "route 192.168.100.0 255.255.255.0"

docker-compose run --rm openvpn ovpn_initpki nopass

docker-compose run --rm openvpn easyrsa build-client-full CLIENT_NAME nopass

docker-compose run --rm openvpn ovpn_getclient CLIENT_NAME > CLIENT_NAME.ovpn
```

### On Mikrotik

Download CLIENT_NAME.ovpn from server.

Split into following files
```
<key>
--- Contents to client.key ---
</key>
<cert>
--- Contents to client.crt ---
</cert>
<ca>
--- Contents to ca.crt ---
</ca>
```

Upload `ca.crt`, `client.crt`, and `client.key` (Files > Browse > Upload)

Import above files (System > Certificates > Import)

Rename `client.crt_0` to `CLIENT_NAME`. On the Certificates page it should have `KT` beside CLIENT_NAME

Add new OVPN Client (PPP > Add New > OVPN Client)

```
Connect To - <Server IP Address>
Port - <OpenVPN Server Port>
Mode - ip
User - CLIENT_NAME
Profile - default-encryption
Certificate - CLIENT_NAME
Auth - sha1
Cipher - aes 256
```

To route all Mikrotik traffic through OPENVPN follow this [guide](https://github.com/missinglink/mikrotik-openvpn-client#configure-the-firewall)

#### To route only some traffic

Set up NAT (IP > Firewall > NAT > Add New)

```
Chain - srcnat
Out. Interface - openVPN
Action - masquerade
```

## More Docs

For more documentation visit https://github.com/kylemanna/docker-openvpn