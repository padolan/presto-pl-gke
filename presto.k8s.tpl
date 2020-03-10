---
apiVersion: v1
kind: Namespace
metadata:
  name: presto 
#---
#apiVersion: v1
#kind: PersistentVolume
#metadata:
#  name: mysql-pv-volume
#  labels:
#    type: local
#spec:
#  storageClassName: manual
#   storage: 2Gi
#  accessModes:
#    - ReadWriteOnce
#  hostPath:
#    path: "/mnt/data"
#---
#apiVersion: v1
#kind: PersistentVolumeClaim
#metadata:
#  name: mysql-pv-claim
#  namespace: presto
#spec:
#  storageClassName: manual
#  accessModes:
#    - ReadWriteOnce
#  resources:
#    requests:
#      storage: 2Gi
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
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: presto
spec:
  ports:
  - port: 3306
  selector:
    app: mysql
  clusterIP: None
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: presto
spec:
  selector:
    matchLabels:
      app: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: password
        ports:
        - containerPort: 3306
          name: mysql
#        volumeMounts:
#        - name: mysql-persistent-storage
#          mountPath: /var/lib/mysql
#      volumes:
#      - name: mysql-persistent-storage
#        persistentVolumeClaim:
#          claimName: mysql-pv-claim
