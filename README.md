# Lurch

Lurch is an application that sits between CloudBees Jenkins application and
GitHub.  It allows you to easily create continuous integration jobs that run
on commits and update the pull request's status on GitHub.

## Deployment

Lurch can easily be deployed to heroku, the only prerequisite is that
you add a `secret_token` environment variable:

``heroku config:set SECRET_TOKEN=`rake secret` ``