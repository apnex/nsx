## install notes

### pull CLI image
```
docker pull apnex/vsp-cli
```

### sddc.parameters
```
mkdir -p cfg
export SDDCDIR="${PWD}/cfg"
docker run apnex/vsp-cli setup-params >"${SDDCDIR}/sddc.parameters"
```

### bash installation
```
docker run apnex/vsp-cli setup-bash > vsp-cli
chmod 755 vsp-cli
cp vsp-cli </root/bin/>
vsp-cli install
```

replace </root/bin/> with a directory in your PATH
