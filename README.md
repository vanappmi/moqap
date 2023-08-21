# moqap

repository for pipeline components, that can be reused across projects

## Ussage

set the following variables:
```
SONARQUBE_PROJECT_KEY: "${CI_PROJECT_NAME}"
SONARQUBE_USER_ID_TOKEN: ""
WHITESOURCE_APIKEY: $wss_apikey
WHITESOURCE_USERKEY: $wss_user_key
WHITESOURCE_PROJECTTOKEN: $wss_project_token
WHITESOURCE_PRODUCTTOKEN: $wss_product_token
DEV_DOCKER_REPO: "cna-${CI_PROJECT_NAME}-docker-stage-dev-local"
```
if possible use the values as described above with the project name