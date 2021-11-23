options(httr_oauth_cache = FALSE)
token = metagce::gce_token(service_account = "default")
bigrquery::bq_auth(token = token)
