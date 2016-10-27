# docker-django-gunicorn-git
Minimal base image for hosting Django websites with Automatic Git Deployment functionalities including Webhooks

This image will pull your Django application code from a git repository with the goal to be displayed by a webserver (gunicorn). As soon as a new code is pushed to that repository, your Django application will be updated.

This image is based on "baseimage:0.9.19" which is very lightweight: it only consumes 6 MB of memory.

## How to configure
This tutorial will explain how to setup this docker-django-git with a Github repository but it can work with other git platforms such as Bitbucket.

### Preparing your SSH key

Let's generate a SSH key with `ssh-keygen -t rsa`. This will produce a public key and a private key. Do not set any password.

The public key *id_rsa.pub* will be used as is.
Open your Github repository, go to *Settings*, and then to *Deploy keys*. Add a new deploy key, set a title and copy/paste the public key.

The private key *id_rsa* will be converted to base64 by running `base64 /path_to_your_key`. This key will be used in the `docker run` command line.
**Note:** Copy the output be careful not to copy your prompt.  

### What your git repository should look like

At the root of your git repository, you should see the following :
```
<NAME_OF_YOUR_DJANGO_PROJECT>/
manage.py
```

### Setup the webhooks

Open your Github repository, go to *Settings*, and then to *Webhooks*. Add a new webhook. Set the payload URL with `http://your-domain-name.com:8555/<YOUR_GIT_HOOK_TOKEN>`. The content type should be `application/json`.

### You're ready to docker run!

```
docker run -d -e 'GIT_REPO=git@github.com:<YOUR-GIT-USERNAME>/<YOUR_GIT_REPOSITORY_NAME>.git' -e 'SSH_KEY=<SSH_KEY=BIG_LONG_BASE64_STRING_GOES_IN_HERE>' -e 'GIT_EMAIL=YOUR_GIT_EMAIL' -e 'GIT_NAME=YOUR_GIT_NAME' -e 'GIT_HOOK_TOKEN=<YOUR_GIT_HOOK_TOKEN>' -e 'DJANGO_PROJECT_NAME=<NAME_OF_YOUR_DJANGO_PROJECT>' bendebled/docker-django-git
```
You should now be able to access your django application with the following url : `http://your-domain-name.com:8000`

Alternately, you can pull a repository and specify a branch add the GIT_BRANCH environment variable:
```
docker run -d -e 'GIT_REPO=git@github.com:<YOUR-GIT-USERNAME>/<YOUR_GIT_REPOSITORY_NAME>.git' -e 'GIT_BRANCH=stage' -e 'SSH_KEY=<SSH_KEY=BIG_LONG_BASE64_STRING_GOES_IN_HERE>' -e 'GIT_EMAIL=YOUR_GIT_EMAIL' -e 'GIT_NAME=YOUR_GIT_NAME' -e 'GIT_HOOK_TOKEN=<YOUR_GIT_HOOK_TOKEN>' -e 'DJANGO_PROJECT_NAME=<NAME_OF_YOUR_DJANGO_PROJECT>' bendebled/docker-django-git
```

## More configuration

### Available Configuration Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

 - **GIT_REPO** : URL to the repository containing your source code
 - **GIT_BRANCH** : Select a specific branch (optional)
 - **GIT_EMAIL** : Set your email for code pushing (required for git to work)
 - **GIT_NAME** : Set your name for code pushing (required for git to work)
 - **SSH_KEY** : Private SSH deploy key for your repository base64 encoded (requires write permissions for pushing)
 - **WEBROOT** : Change the default webroot directory from `/var/www/html` to your own setting
 - **TEMPLATE_NGINX_HTML** : Enable by setting to 1 search and replace templating to happen on your code
 - **DOMAIN** : Set domain name for Lets Encrypt scripts
 - **GIT_HOOK_TOKEN** : Auth-Token used for the [docker-hook](https://github.com/schickling/docker-hook) listener
 - **DJANGO_PROJECT_NAME** : The name of your Django project

## Ressources
These links might help your if you want to learn about this docker image

 * http://docs.gunicorn.org/en/stable/deploy.html
 * https://github.com/schickling/docker-hook
 * https://gist.github.com/oodavid/1809044
 * https://www.portent.com/blog/design-dev/github-auto-deploy-setup-guide.htm

## Thanks to
* [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker/) - Performance oriented base image
* [ngineered/nginx-php-fpm](https://github.com/ngineered/nginx-php-fpm) - Git push/pull functionalities
* [schickling/docker-hook](https://github.com/schickling/docker-hook) - Git Webhook listener

This project is forked from [eduwass/docker-nginx-git](https://github.com/eduwass/docker-nginx-git)
