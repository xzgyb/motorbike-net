# 用户

## 获取手机短信校验码 

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/users/ validation_code?phone=13812345678&type=1
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

使用`创建oauth应用`步骤获取的Application Id和Secret， 用手机号作为oauth密码登录方式的用户名， 用`注册用户`步骤获取的oauth_login_code作为oauth密码登录方式的密码, 进行oauth登录，具体用法可参见相关的第三方库使用说明.

如果oauth登录成功，则返回token，refresh_token，expires_in，expires_in为超时时间，服务器端设置为1天.

如果oauth登录失败，返回{"error":"错误原因"}.

另外也可以使用用户名，email，手机号作为oauth密码登录方式的用户名，使用账户的密码作为oauth密码登录方式的密码。

## 使用oauth的token访问资源

使用`oauth登录`步骤获取的token，来访问服务器的资源，具体用法可参见相关的第三方库使用说明.

如果token超时，则使用refresh_token重新获取新的token进行资源访问。

## 设置用户名和密码

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
name                  | 是       | 用户名 
password              | 是       | 密码
password_confirmation | 是       | 确认密码

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

