# won't work atm, just getting a basic app out there
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: presto
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
spec:
  selector:
    app: presto 
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080 
