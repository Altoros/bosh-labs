# Add BOSH Links to greater release


### Edit app job spec

Open the file `jobs/app/spec` in a text editor and add the following lines:
```
provides:
- name: app_connection
  type: connection
  properties:
  - port
```   

### Edit router job spec

Open the file `jobs/router/spec` in a text editor and add the following lines:
```
consumes:
- name: app_connection
  type: connection
```

### edit router template
Open the file `jobs/router/templates/config.yml.erb` and replace contents with following:

```
---
upstreams: ["<%= link('app_connection').instances[0].address %>:<%= link('app_connection').p('port') %>"]
```

### create and upload updated release
```
bosh create-release --force
bosh upload-release
```

### remove upstreams configuration from deployment template and deploy new release

```
jobs:
- name: router
  release: greeter-release
  properties:
    upstreams:
      - 10.0.255.7:8080
```

```
bosh -d greeter -n deploy greeter.yml
```

### check properties that properties on router job equal to removed upstreams from manifests

```
bosh -d greeter ssh router
cat /var/vcap/jobs/router/config/config.yml
```
