apiVersion: getambassador.io/v2
kind: Mapping
metadata:
  name: kubernetes-dashboard-admin
  namespace: ${namespace}
spec:
  ambassador_id:
  - ambassador-internal
  prefix: /dashboard-admin/
  service: ${namespace}.{$service_name}:80

--- 

apiVersion: getambassador.io/v2
kind: Mapping
metadata:
  name: kubernetes-dashboard-readonly
  namespace: ${namespace}
spec:
  add_request_headers:
    Authorization: Bearer ${token}
  ambassador_id:
  - ambassador-internal
  prefix: /dashboard/
  service: ${namespace}.${service_name}:80

