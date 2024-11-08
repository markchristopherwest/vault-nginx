# Vault LAMP

This repo yields a HashiCorp Vault instance with Vault Agent using docker compose.

## Create Vault & LAMP via Docker Compose

```bash

./run all

```

## Create Vault with Vault Agent

```bash

# To verify your vault agent:

docker logs agent

# To verify your vault server:

docker logs vault

# To verify your vault setup (including TF apply):

docker logs setup

# Now, to verify Vault agent connectivity (token retry etc.):

docker logs agent -f

# In a new terminal:

docker stop vault

# Observe the retry behavior

docker start vault

# Clean Up

./run cleanup

```


