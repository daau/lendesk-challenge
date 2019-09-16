# Lendesk challenge


## Installation
This is a simple Rails 5.2 application which uses Redis as its database. No configuration is needed for a development server, assuming a local Redis instance is running with the following settings (ie, the default settings)

Option | Value
------------ | -------------
Host | "127.0.0.1" (localhost)
Port | 6379
DB | 0


Then, 
```
$ bundle install
$ rails s
```

The API server will be running at http://api.lvh.me:3000

## Usage
The following endpoints are available:

Endpoint | Verb | Parameters | Description
------------ | ------------- | ------------- | -------------
http://api.lvh.me:3000/users | POST | *username:string, password:string* | Create a new user
http://api.lvh.me:3000/sessions | POST | *username:string, password:string* | Authenticate a user

**Examples: Creating a user**
```
$ curl -v -d '{"username":"daau", "password":"hi"}' -H "Content-Type: application/json" POST http://api.lvh.me:3000/users
< STATUS 422 {"password":["is too short (minimum is 6 characters)"]}

$ curl -v -d '{"username":"daau", "password":"hunter2"}' -H "Content-Type: application/json" POST http://api.lvh.me:3000/users
< STATUS 201 {"username":"daau","password_digest":"$2a$12$4vE34GO5cy0K4OxbiFreluk3knxe0ssg.h/gftE4PC.bl8O1ocIAK"}

$ curl -v -d '{"username":"daau", "password":"hunter2"}' -H "Content-Type: application/json" POST http://api.lvh.me:3000/users
< STATUS 422 {"username":["has already been taken"]}
```

**Examples: Authenticating a user**
```
$ curl -v -d '{"username":"daau", "password":"foobar"}' -H "Content-Type: application/json" POST http://api.lvh.me:3000/sessions
< STATUS 401 {"errors":"invalid password"}

$ curl -v -d '{"username":"daau", "password":"hunter2"}' -H "Content-Type: application/json" POST http://api.lvh.me:3000/sessions
< STATUS 200 {"username":"daau","password_digest":"$2a$12$4vE34GO5cy0K4OxbiFreluk3knxe0ssg.h/gftE4PC.bl8O1ocIAK"}
```

## Discussion
Due to time considerations, I kept the implementation as minimal as possible by following the "Rails way". A plain-old-ruby-class *User* serves as the underlying class for the *User resource*, and derives functionality from the following ActiveModel modules:

1. **ActiveModel::Validations**, to handle validations of fields
2. **ActiveModel::SecurePassword**, to handle the encryption of passwords and authentication of users
3. **ActiveModel::Serialization**, to handle serialization to json
4. **ActiveModel::AttributeAssignment**, for a cleaner attribute assignment interface

In addition, the following modules were wrriten and included in *User* for further functionality

1. **ActiveHash**, a minimal ORM for Redis with some additional helper methods
2. **UniqueKeyValidator**, which validates that certain attributes are unique (in this case, it's used to ensure the *username* attribute is unique)


## Further improvements
Due to time considerations, some functionality has been left out. In a production setting, the following features would ideally be implemented:
1. A persistent database (and with it, the usage of ActiveRecord)
2. A means to manage user session state (for example, JSON web tokens)
3. API versioning
4. HTTPS enforcement to prevent requests from being sniffed
5. API rate limiting (for example, using Rack::Attack)
6. Extraction ActiveHash into a gem and write documentation for it (if we really need to use Redis)
7. Many improvements to ActiveHash (which warrents further technical discussion)
8. Model and integration tests
9. More descriptive error messages (which warrants further business / technical discussion)
10. More appropriate json responses (which warrants further business / technical discussion)
11. Uniqueness identification for each User record in Redis (eg, a sequentailly increasing ID)