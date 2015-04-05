# Engine Yard New Task

### Requirements
* [engine yard](https://github.com/engineyard/engineyard)

### Options
* __`account`__: Name of the account in which the application and environment can be found
* __`app`__: The application to deploy
* __`environment`__: The environment to which you want this application to deploy

```yaml
tasks:
  engine_yard:
    account: personal
    app: my_app
    environment: production
```
