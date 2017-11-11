# README

[![Code Climate](https://codeclimate.com/github/lucatironi/rails-5-api-jwt/badges/gpa.svg)](https://codeclimate.com/github/lucatironi/rails-5-api-jwt) [![Test Coverage](https://codeclimate.com/github/lucatironi/rails-5-api-jwt/badges/coverage.svg)](https://codeclimate.com/github/lucatironi/rails-5-api-jwt/coverage) [![Build Status](https://travis-ci.org/lucatironi/rails-5-api-jwt.svg?branch=master)](https://travis-ci.org/lucatironi/rails-5-api-jwt)

Rails 5 API (--api) using [Warden](https://github.com/hassox/warden) to authenticated requests with [JSON Web Tokens](https://jwt.io/). Updated from [my other repository](https://github.com/lucatironi/example_rails_api) and using [Docker Compose](https://docs.docker.com/compose/).

## Setup the app

Build the docker containers:

```
$ docker-compose build
```

Bundle the gems (it uses a volume):

```
$ docker-compose run bundle
```

Run the `bin/setup` script

```
$ docker-compose run web bin/setup
```

## Running and testing the app

Run the containers

```
$ docker-compose up
```

Run the specs

```
$ docker-compose exec web bundle exec spec
```

Test the API with Curl

```
$ curl -i -X POST -H "Content-Type:application/json" -d '{"email":"user@example.com", "password":"password"}' http://localhost:3000/authentications.json
```

The response will contain the JSON Web Token

```
{"auth_token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIloxLCJleHAiOjE1MTA1MTcwMzd9.S4c2YwqajvZupSQdeK5dwn8h8JSO90S851ua36Gz2s0"}
```

Use it with another request to an authenticated endpoint, passing it as a an `Authorization` header

```
$ curl -i -H "Content-Type:application/json" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIloxLCJleHAiOjE1MTA1MTcwMzd9.S4c2YwqajvZupSQdeK5dwn8h8JSO90S851ua36Gz2s0" http://localhost:3000/customers.json
```
