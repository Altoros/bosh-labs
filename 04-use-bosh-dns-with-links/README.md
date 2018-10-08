# Use BOSH DNS with links in greater release

### Open the file `jobs/router/templates/config.yml.erb` and replace existing content:

```
---
upstreams: ["<%= link('app_connection').instances[0].address %>:<%= link('app_connection').p('port') %>"]
```
with following:
```
---
upstreams: ["<%= link('app_connection').address %>:<%= link('app_connection').p('port') %>"]
```

### create and upload release
```
bosh create-release --force
bosh upload-release
```

### check current properties on router job
```
bosh -d greeter ssh router
cat /var/vcap/jobs/router/config/config.yml
```

### redeploy greeter deployment

```
bosh -d greeter -n deploy greeter.yml
```

### login to router and check config again
```
bosh -d greeter ssh router
cat /var/vcap/jobs/router/config/config.yml
```

### remove static ips from deployment manifest

check current IPs of VMs

```
bosh vms
```
remove static ips declarations from manifest and redeploy deployment
```
static_ips:
- 10.0.255.8
```
```
bosh -d greeter -n deploy greeter.yml
```

check jobs IPs
```
bosh vms
```
login to router and run curl command
```
bosh -d greeter ssh router
curl localhost:8080
```


### scale app instances and verify bosh dns is working

change number of instances in manifest to 2 and redeploy

```
instance_groups:
- name: app
  azs:
  - z2
  instances: 2
```

```
bosh -d greeter -n deploy greeter.yml
```

login on router job and try to curl few times and see result

```
bosh -d greeter ssh router
curl localhost:8080
```
