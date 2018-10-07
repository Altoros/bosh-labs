# Add BOSH Links to greater release

### edit router template
```
---
upstreams: ["<%= link('app_connection').address %>:<%= link('app_connection').p('port') %>"]
```

### create and upload release
```
bosh create-release --force
bosh upload-release
```

###  remove static ips from deployment template and deploy new release

```
static_ips:
- 10.0.255.8
```


```bosh -d greeter -n deploy greeter.yml```
