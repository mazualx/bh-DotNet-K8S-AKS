| Language | Framework | Platform | Author |
| -------- | -------- |--------|--------|
| ASP.NET Core | .NET Core 2.2 | Azure Web App, Virtual Machines |


# ASP.NET Core MVC application

Sample ASP.NET Core MVC application.

## Devops assignment

This is the documentation for the DevOps assignment.

In order to create the infrastructure, I have used terraform scripts that can be found in `aspnet-core-dotnet-core/infra folder`. 

Note: 
* You need to add: appdid, principalId, secretId in the `variables.tf` file.
* You also need to add a unique name for the ACR repo on the `AKS.tf` file.

Once these are populated, simply run `terraform init && terraform apply`, and the infrastructure should ne completed.

On the pipeline side of things, we have used Azure yaml file to automate the CI/CD and the file can be found in aspnet-core-dotnet-core/azure-pipelines.yml. There is also a reference to manifests folder, that is going to deploy the Kubernetes resources.

In order for the pipeline to be ready, you need also to create:
* Service Connection to ACR
* One Service Connection for every namespace/environment on the K8S side

If everything worked well, you should see the following output at the pipeline level:
`service aspdotnet external IP is 20.105.3.209`
If you follow the LB IP with 8080 port, you should see the app running

![alt text](image.png)

Add the end, use `terraform destroy` to remove the entire infrastructure.

