# Talos based Kubernetes Implementation

This project provides a reference implementation of a Kubernetes cluster using Talos. Talos is a CNCF-hosted project that provides a vendor-neutral, open source distribution of Kubernetes.

This project includes the following components:

* Kubernetes cluster
* sample application

## Getting Started

To get started, you will need to install Talos and Kubernetes. 
```
cd terraform
terraform init -backend-config ./01-talos-qualif-mgoulin.tfvars
terraform plan -var-file ./tfvars/01-talos-qualif-mgoulin.tfvars -out plan.out
terraform apply plan.out
```

## Using the Cluster

Once you have created a Kubernetes cluster, you can use it to deploy and manage applications. 
```
cd terraform
terraform output -raw kubeconfig > ../kubeconfig
cd ..
export KUBECONFIG=./kubeconfig
# now you can use kubectl ...
```

## Contributing
We welcome contributions to this project. Please read the CONTRIBUTING.md file for more information.

## License
This project is licensed under the Apache License 2.0.