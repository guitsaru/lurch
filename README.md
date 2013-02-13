## Deployment

Lurch can easily be deployed to heroku, the only prerequisite is that
you add a `secret_token` environment variable:

``heroku config:set SECRET_TOKEN=`rake secret` ``
