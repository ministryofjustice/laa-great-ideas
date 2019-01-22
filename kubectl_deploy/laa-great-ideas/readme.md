# Kubectl Deploy

As an interim measure until the CI pipline is complete, Great Ideas can be deployed to the MoJ Cloud Platform manually using kubectl.

The following namespaces have been created
laa-great-ideas-uat
laa-great-ideas-staging
laa-great-ideas-production

Currently the deployment files are configured for UAT, and the RDS database is present only in UAT.

## Deployment

1. Configure git-crypt and get your public GPG key added to the laa-great-ideas-repo - 
https://ministryofjustice.github.io/cloud-platform-user-docs/03-other-topics/001-git-crypt-setup/#git-crypt

2. Check out the branch you wish to deploy

3. Configure kubectl - https://ministryofjustice.github.io/cloud-platform-user-docs/01-getting-started/001-kubectl-config/#multiple-clusters

4. Get the ECR repo keys - https://ministryofjustice.github.io/cloud-platform-user-docs/01-getting-started/001-kubectl-config/#multiple-clusters

5. Build and push the docker image - https://ministryofjustice.github.io/cloud-platform-user-docs/02-deploying-an-app/001-app-deploy/#pushing-application-to-ecr

6. Deploy the application to the cluster - 
https://ministryofjustice.github.io/cloud-platform-user-docs/02-deploying-an-app/001-app-deploy/#deploying-application-to-the-cluster

Helpful commands

Get pod information 

`kubectl get pods --namespace laa-great-ideas-uat`

Describe a pod

`kubectl -n laa-great-ideas-uat describe pod laa-great-ideas-<pod-ID>`

Connect to a pod

`kubectl exec --stdin --tty --namespace laa-great-ideas-uat laa-great-ideas-<pod-ID> -- /bin/bash`