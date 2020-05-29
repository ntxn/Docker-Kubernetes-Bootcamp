docker build -t ngantxnguyen/multi-client:latest -t ngantxnguyen/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t ngantxnguyen/multi-server:latest -t ngantxnguyen/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t ngantxnguyen/multi-worker:latest -t ngantxnguyen/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push ngantxnguyen/multi-client:latest
docker push ngantxnguyen/multi-server:latest
docker push ngantxnguyen/multi-worker:latest
docker push ngantxnguyen/multi-client:$SHA
docker push ngantxnguyen/multi-server:$SHA
docker push ngantxnguyen/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=ngantxnguyen/multi-server:$SHA
kubectl set image deployments/client-deployment client=ngantxnguyen/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=ngantxnguyen/multi-worker:$SHA