---
apiVersion: v1
kind: Namespace
metadata:
  name: presto 
---
# may not work atm, just getting a basic app out there
apiVersion: apps/v1
kind: Deployment
metadata:
  name: presto
  namespace: presto
  labels:
    app: presto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: presto
  template:
    metadata:
      labels:
        app: presto
    spec:
      containers:
      - name: presto
        image: PRESTO_IMAGE_URL 
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: presto
  namespace: presto
spec:
  type: LoadBalancer
  selector:
    app: presto 
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: presto
  namespace: presto
spec:
  rules:
  - http:
      paths:
      - path: /*
        backend:
          serviceName: presto
          servicePort: 80
