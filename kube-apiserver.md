### kube-apiserver
```
[ req ]
default_bits       = 4096
distinguished_name = req_distinguished_name
req_extensions     = req_ext

[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
countryName_default         = GB
stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = England
localityName                = Locality Name (eg, city)
localityName_default        = Brighton
organizationName            = Organization Name (eg, company)
organizationName_default    = Hallmarkdesign
commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_max              = 64
commonName_default          = localhost

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS.1   = your-website.dev
DNS.2   = another-website.dev

```
