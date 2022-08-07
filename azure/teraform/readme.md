### Create credentials Azure for tf
```
az login
az ad sp create-for-rbac --name "user-terraform-iac-management" --role contributor --scopes /subscriptions/<subscriptions id> --sdk-auth
```

