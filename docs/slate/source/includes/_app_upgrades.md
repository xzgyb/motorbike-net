# APP升级  

## 获取App的最新版本

> 调用实例:

```shell
curl 'http://localhost:3000/api/v1/app_versions/newest?name=MotorbikeApp
```

> 返回:

```json
{"result":1,"version":"1.0.1"}
```

### HTTP请求

`GET /api/v1/app_versions/newest`

### 请求参数

参数名                | 是否必需 | 描述
----------------------|----------|------
name                  | 是       | App名称 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"version":"版本号"}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取指定App版本的app url

> 调用实例:

```shell
curl 'http://localhost:3000/api/v1/app_versions/url?name=MotorbikeApp&version=1.1.0'
```

> 返回:

```json
{"result":1,
  "url":"http://localhost:3000/uploads/app_version/568a0071627e27351400002/MotorbikeApp.apk"}
```

### HTTP请求

`GET /api/v1/app_versions/url`

### 请求参数

参数名                | 是否必需 | 描述
----------------------|----------|------
name                  | 是       | App名称 
version               | 是       | 版本号 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"url":"app的完整url"}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取指定App版本的变更内容

> 调用实例:

```shell
curl 'http://localhost:3000/api/v1/app_versions/changelog?name=MotorbikeApp&version=1.1.0'
```

> 返回:

```json
{"result":1,
  "changelog":"增加了登录功能"}
```

### HTTP请求

`GET /api/v1/app_versions/changelog`

### 请求参数

参数名                | 是否必需 | 描述
----------------------|----------|------
name                  | 是       | App名称 
version               | 是       | 版本号 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"changelog":"app的变更内容"}`, 这个变更内容在网站端可以用markdown的语法输入，返回的是html内容，app端可以放到webview中显示
失败  | `{"result":0,"error":"错误原因"}`
