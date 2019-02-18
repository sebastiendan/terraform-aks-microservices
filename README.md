# terraform-aks-microservices

## What is this?
An all inclusive terraform recipe for micro-services architecture deployed on Kubernetes (AKS), from ECR docker images (AWS), with Route53 DNS records (AWS), Traefik load balancer, Let's Encrypt SSL certs, MySQL one-DB-per-microservice, blob storage, and much more...

## Run the whole stack (e. g. in a CI pipelines)

            - # docker login
            - eval $(aws ecr get-login --no-include-email)

            - # provision db server
            - cd db-server
            - terraform init
            - terraform apply -auto-approve
            - cd ..

            - # provision blob storage
            - cd blob-storage
            - terraform init
            - terraform apply -auto-approve
            - export TF_VAR_BLOB_STORAGE_ACCOUNT_NAME=$(terraform output account_name)
            - export TF_VAR_BLOB_STORAGE_ACCOUNT_ACCESS_KEY=$(terraform output account_access_key)
            - cd ..

            - # provision the cluster
            - export TF_VAR_CLIENT_ID=${ARM_CLIENT_ID}
            - export TF_VAR_CLIENT_SECRET=${ARM_CLIENT_SECRET}
            - cd cluster
            - terraform init
            - terraform apply -auto-approve

            - # export KUBECONFIG
            - mkdir ~/.kube
            - terraform output kube_config > ~/.kube/aksconfig
            - export KUBECONFIG=~/.kube/aksconfig
            - cd ..

            - # deploy traefik
            - cd traefik
            - kubectl apply -f ./ingress-role.yaml
            - terraform init
            - terraform apply -auto-approve -var "AWS_ACCESS_KEY_ID=$ACME_AWS_ACCESS_KEY_ID" -var "AWS_SECRET_ACCESS_KEY=$ACME_AWS_SECRET_ACCESS_KEY" -var "AWS_HOSTED_ZONE_ID=$AWS_HOSTED_ZONE_ID"
            - kubectl apply -f ./ingress.yaml
            - export EXTERNAL_IP=$(terraform output external_ip)
            - cd ..

            - # deploy services
            - cd services
            - terraform init
            - terraform apply -auto-approve
            - cd ..

            - # set dns
            - cd dns
            - terraform init
            - terraform apply -auto-approve -var "external_ip=$EXTERNAL_IP"
