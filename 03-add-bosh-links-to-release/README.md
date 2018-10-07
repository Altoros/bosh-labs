# Add BOSH Links to greater release


### Edit app job spec

Open the file `jobs/app/spec` in a text editor and add the following lines:
```
---
name: app
templates:
  ctl: bin/ctl

packages:
- greeter
- ruby

provides:
- name: app_connection
  type: connection
  properties:
  - port

properties:
  port:
    description: "Port on which server is listening"
    default: 8080
```   

### Edit router job spec

Open the file `jobs/router/spec` in a text editor and add the following lines:
```
---
name: router
templates:
  ctl: bin/ctl
  config.yml.erb: config/config.yml

packages:
- greeter
- ruby

consumes:
- name: app_connection
  type: connection

properties:
  port:
    description: "Port on which server is listening"
    default: 8080
  upstreams:
    description: "List of upstreams to proxy requests"
    default: []
```

### edit router template

```
---
upstreams: ["<%= link('app_connection').instances[0].address %>:<%= link('app_connection').p('port') %>"]
```

### create and upload release
```
bosh create-release --force
bosh upload-release
```

### finally remove upstreams from deployment template and deploy new release

```
jobs:
- name: router
  release: greeter-release
  ~~properties:
    upstreams:
      - 10.0.255.7:8080~~
```

```bosh -d greeter -n deploy greeter.yml```
