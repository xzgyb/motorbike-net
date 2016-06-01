# 上传媒体文件

## 为当前登录用户上传文件

> 调用实例:

```shell
curl -X PUT http://localhost:3000/api/v1/medias/upload 
     -F 'type=1' 
     -F 'access_token=a69b7ce2bb7b7b1ac7fcefda2fcf9abddd86f203c0d38ba94c2e9f1e2486b0e3' 
     -F "media=@/vagrant/aa.jpg;type=image/jpeg"
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/medias`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
type       | 是       | 上传的文件类型, 1: 图片 2: 视频 3: 音频
media      | 是       | 上传的文件内容


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

<aside class="warning">
body的编码部分使用multipart/form-data
</aside>

## 获取登录用户的已上传的文件列表

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/medias
```

> 返回:

```json
{"result":1,
 "medias":[{"id":2,
             "type":1,
             "url":"http://localhost:3000/uploads/media/media/568cccc863623925ad000000/a1.jpg"},
            {"id":3,
             "type":1,
             "url":"http://localhost:3000/uploads/media/media/568ccccb63623925ad000001/a1.jpg"}]}
```

### HTTP请求

`GET /api/v1/medias`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
type       | 是       | 要获取的文件类型, 1: 图片 2: 视频 3: 音频


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"medias":[<media>,...]}`, 其中medias是media类型的数组，表示用户已上传的文件列表
失败  | `{"result":0,"error":"错误原因"}`

#### media类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整数 | 一条媒体文件信息记录的id
type                 | 整数   | 文件类型, 1: 图片 2: 视频 3: 音频
url                  | 字符串 | 媒体文件的url 

## 为当前登录用户删除一个已上传的文件

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/medias/2
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/medias/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 要删除的一条媒体文件信息记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


## 为当前登录用户删除所有已上传的文件

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/medias
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/medias`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
type       | 是       | 要删除的文件类型, 1: 图片 2: 视频 3: 音频


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


