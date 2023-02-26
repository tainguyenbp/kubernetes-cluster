link ref
```
https://cloudinfrastructureservices.co.uk/setup-gitlab-sso-with-azure-ad-single-sign-on/


```


```
 gitlab_rails['omniauth_providers'] = [
    {
      "name" => "azure_oauth2",
      "args" => {
        "client_id" => "CLIENT ID",
        "client_secret" => "CLIENT SECRET",
        "tenant_id" => "TENANT ID",
      }
    }
  ]
  
```

```
sudo gitlab-ctl reconfigure

sudo gitlab-ctl restart

```
