# 用户

## 获取手机短信校验码 

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/users/validation_code?phone=13812345678&type=1
```
> 返回:

```json
{"result":1}
```

### HTTP请求

`GET /api/v1/users/validation_code?phone=<phone>&type=<type>`

### 请求参数

参数名 | 是否必需 | 描述
-------|----------|------
phone  | 是       | 为了要获取校验码的手机号
type   | 是       | 校验码的使用类型<br><br>**1**为获取注册用的校验码<br>**2**为获取登录用的校验码<br>**3**为获取重置密码的校验码

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

<aside class="warning">
注意:
<ul>
<li>服务器向云信发送请求的时间间隔为1分钟，1分钟内重复发送校验码请求，将失败.</li>
<li>校验码的有效期为10分钟，超过10分钟注册，将失败.</li>
</ul>
</aside>

## 注册用户

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST 
     -d '{"phone":"13812345678","validation_code":"904283"}'
      http://localhost:3000/api/v1/users/register
```

> 返回:

```json
{"result":1,"oauth_login_code":"3224234234"}
```

### HTTP请求

`POST /api/v1/users/register`

### POST请求参数

参数名          | 是否必需 | 描述
----------------|----------|------
phone           | 是       | 手机号
validation_code | 是       | 手机上收到的短信校验码, 这个校验码是使用`获取手机短信校验码`步骤请求参数type=1获得的

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,oauth_login_code:"oauth登陆码"}`<br>这个oauth登陆码需要保存起来，为了下一步oauth登录用.
失败  | `{"result":0,"error":"错误原因"}`

## oauth登录

网站api的调用是使用OAuth access_token的方式，app端和硬件模块端最好用统一的方式使用。 基本的流程如下：

  1. 获取access_token.

  2. 第1步返回的结果中，取出access_token, refresh_token, expires_in, 保存起来，使用access_token调用网站api.

  3. 当使用access_token 超时导致调用网站api失败时，使用refresh_token换取新的access_token, 这会返回个
        新的access_token和refresh_token, 然后保存起来，使用这个新的access_token调用网站api.

  4. 在获取access_token 返回的结果中，还有个expires_in字段，表示多少秒后超时，
      客户端也可以使用这个值来判断access_token 是否超时.


## 使用oauth登录码获取token

使用手机号作为username, oauth登录码作为password获取token.  (目前主要用这种方式).

```shell
使用注册用户api (POST /api/v1/users/register) 或
用户登录api (POST /api/v1/users/login),
会返回 {"result":1,oauth_login_code:"7274e2fcbbcc402f0abb"} 
这个oauth_login_code即 为oauth登录码

curl -H 'Content-Type:application/json'
     --request POST
     -d '{"grant_type":"password",
          "username":"13889210325",
          "password":"7274e2fcbbcc402f0abb",
          "client_id":"3a1ef442",
          "client_secret":"14bd5fd3ef8dbd0e3e28cfa959c72a6549824aa0632a74bbb6bf8ab76ab298b4"}'
     http://localhost:3000/oauth/token

这里的username为手机号，
password为oauth登录码, 
client_id, client_secret 为通过网站创建oauth application返回的
application id, application secret,
跟Android版app的client_id, client_secret相同。

调用成功后返回
       
{"access_token":"9ae1324adf000f7a8a39903381daf92a4793db0170e38f4c109b41d5db3854b4",
 "token_type":"bearer",
 "expires_in":86400,
 "refresh_token":"d59d00b92c2120da9a5e3ad9606bcdf283ee380610ebec36b0c66b63226e329c",
 "created_at":1472442551}

使用这个access_token进行网站api的调用.
另外这个expires_in字段，表示这个access_token多少秒后超时，
当前值为 86400秒,24小时后过期.

```

## 使用用户名，email，手机号获取token

使用用户名，email，手机号作为username，使用实际的密码作为password获取token.

```shell
1. 使用用户名， 密码获取
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"grant_type":"password",
          "username":"gyb",
          "password":"11111111",
          "client_id":"3a1ef442",
          "client_secret":"14bd5fd3ef8dbd0e3e28cfa959c72a6549824aa0632a74bbb6bf8ab76ab298b4"}'
     http://localhost:3000/oauth/token

2. 使用手机号， 密码获取
curl -H 'Content-Type:application/json'
    --request POST
    -d '{"grant_type":"password",
         "username":"13889210325",
         "password":"11111111",
         "client_id":"3a1ef442",
         "client_secret":"14bd5fd3ef8dbd0e3e28cfa959c72a6549824aa0632a74bbb6bf8ab76ab298b4"}'
    http://localhost:3000/oauth/token

3. 使用email， 密码获取
curl -H 'Content-Type:application/json'
    --request POST
    -d '{"grant_type":"password",
         "username":"xzgaoyanbing@163.com",
         "password":"11111111",
         "client_id":"3a1ef442",
         "client_secret":"14bd5fd3ef8dbd0e3e28cfa959c72a6549824aa0632a74bbb6bf8ab76ab298b4"}'
    http://localhost:3000/oauth/token
```

## refresh token换取access token 

OAuth access token 有超时设定，默认是1天, 当使用这个access_token调用网站api失败时，需要 使用refresh_token获取新的 access token: 

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"grant_type":"refresh_token",
          "refresh_token":"d59d00b92c2120da9a5e3ad9606bcdf283ee380610ebec36b0c66b63226e329c",
          "client_id":"1dc42851",
          "client_secret":"3a0b4e498f235b2d401b8f425b104a68bdfb2057321d3dbe6dd7b416fc6eef7a"}'
     http://localhost:3000/oauth/token

调用成功后，会返回

{"access_token":"1d725643db780d65951347b1c046771d89e88cd35598378a2a96ea3587fecf62",
"token_type":"bearer",
"expires_in":86400,
"refresh_token":"ffea94a92a92d23aac1f45bfb2c19d229043bd47fb305396c6b369c97c7dfb04",
 "created_at":1472442613}

在使用这个新的access_token来调用网站api.
```

## 设置用户信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT 
     -d '{"name":"gyb","password":"12345678","password_confirmation":"12345678"}' 
     http://localhost:3000/api/v1/users/update
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/users/update`

### PUT请求参数

参数名                | 是否必需 | 描述
----------------------|----------|------
name                  | 否       | 用户名 
password              | 否       | 密码
password_confirmation | 否       | 确认密码
avatar                | 否       | 用户头像

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 用户登录

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST 
     -d '{"phone":"13812345678","validation_code":"904283"}'
     http://localhost:3000/api/v1/users/login
```

> 返回:

```json
{"result":1,"oauth_login_code":"3224234234"}
```

### HTTP请求

`POST /api/v1/users/login`

### POST请求参数

参数名          | 是否必需 | 描述
----------------|----------|------
phone           | 是       | 手机号
validation_code | 是       | 手机上收到的短信校验码, 这个校验码是使用`获取手机短信校验码`步骤请求参数type=2获得的

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,oauth_login_code:"oauth登陆码"}`<br>这个oauth登陆码需要保存起来，为了下一步oauth登录用.
失败  | `{"result":0,"error":"错误原因"}`


## 重置用户名和密码 

> 调用实例:

```shell
curl -H 'Content-Type:application/json' 
     --request PUT
     -d '{"phone":"13812345678",
          "validation_code":"904483",
          "password":"12345678",
          "password_confirmation":"12345678"}'
     http://localhost:3000/api/v1/users/reset
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/users/reset`

### PUT请求参数

参数名          | 是否必需 | 描述
----------------|----------|------
phone           | 是       | 手机号
validation_code | 是       | 手机上收到的短信校验码, 这个校验码是使用`获取手机短信校验码`步骤请求参数type=3获得的
password        | 是       | 密码
password_confirmation | 是 | 确认密码

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

## 查询用户
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/users/query/jo
```
> 返回:

```json
{"result":1,
 "users":[
    {"id":1, "name":"john", "avatar_url":"http://localhost:3000/upload/avatar/1.png"},
    {"id":2, "name":"joyce", "avatar_url":"http://localhost:3000/upload/avatar/2.png"}
  ],
 "paginate_meta": {"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":2}
}
```

### HTTP请求

`GET /api/v1/users/query/:user_name_or_phone_or_email`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
user_name_or_phone_or_email  | 否       | 要查询的用户名，可以只指定用户名的前缀部分，或者指定要查询的手机号，或者指定要查询的email. 如果不指定该参数，则查询所有用户.
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","users":[<user>, ...],"paginate_meta":<paginate_meta>}`, 其中`users`为一数组，元素类型为user, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### user类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 用户id
name                 | 字符串 | 用户名称
phone                | 字符串 | 用户手机号
email                | 字符串 | 用户邮件
avatar_url           | 字符串 | 用户头像url

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数

## 查询指定用户id的详细信息
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/users/2
```
> 返回:

```json
{"result":1,
 "user":{
    "id":2,
    "name":"john",
    "email":"email45@hello.com",
    "title":"3级飞车党",
    "level":"LV.3",
    "travel_mileage": "2.0",
    "avatar_url":"http://localhost:3000/upload/avatar/2.png"
  }
}
```

### HTTP请求

`GET /api/v1/users/:id`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 否       | 用户id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","user":<user>`, 其中`user`为带有详细用户信息的user
失败  | `{"result":0,"error":"错误原因"}`

#### user类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 用户id
name                 | 字符串 | 用户名称
email                | 字符串 | 用户email
title                | 字符串 | 用户头衔
level                | 字符串 | 用户级别 
travel_mileage       | 字符串 | 行驶里程
avatar_url           | 字符串 | 用户头像url

## 查询当前用户的详细信息

> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/users/info
```
> 返回:

```json
{"result":1,
 "user":{
    "id":2,
    "name":"john",
    "email":"email45@hello.com",
    "title":"3级飞车党",
    "level":"LV.3",
    "travel_mileage": "2.0",
    "avatar_url":"http://localhost:3000/upload/avatar/2.png"
  }
}
```

### HTTP请求

`GET /api/v1/users/info`

### 请求参数

无

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","user":<user>`, 其中`user`为带有详细用户信息的user
失败  | `{"result":0,"error":"错误原因"}`

#### user类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 用户id
name                 | 字符串 | 用户名称
email                | 字符串 | 用户email
title                | 字符串 | 用户头衔
level                | 字符串 | 用户级别 
travel_mileage       | 字符串 | 行驶里程
avatar_url           | 字符串 | 用户头像url
