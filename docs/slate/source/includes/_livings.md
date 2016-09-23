# 直播

## 获取直播的列表
> 调用实例:

```shell

返回全部的living

curl --request GET  http://localhost:3000/api/v1/livings?longitude=32.3&latitude=62.9

返回朋友圈内的living

curl --request GET  http://localhost:3000/api/v1/livings?circle=1&longitude=32.3&latitude=62.9
```

> 返回:

```json
{ "result":1,
  "livings":[
    {"id":1,
     "user_id":2,
     "user_name":"user1",
     "user_avatar_url":"http://localhost:3000/upload/avatar/1.png",
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":"32.5",
     "latitude":"62.8",
     "distance":110,
     "updated_at":"2016-04-20 14:49:56",
     "videos":[{"url":"http://115.29.110.82/public/uploads/sample.mp4",
                "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
                "id":2}],
     "likes":[
        {"id":1, "user_id":2, "user_name":"ggg"},
        {"id":2, "user_id":3, "user_name":"www"}
     ],
     "total_likes_count":2,
     "comments":[
        {"id":1, "user_id":2, "user_name":"ggg", "content": "hello"},
        {"id":2, "user_id":3, "user_name":"www",
            "content": "world", "reply_to_user_id": 1, "reply_to_user_name": "ggg"}     ],
     "total_comments_count":2
      },
     
     ...],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```

### HTTP请求

`GET /api/v1/livings`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
per_like_page   | 否       | 指定每次最多返回多少条点赞记录
per_comment_page   | 否       | 指定每次最多返回多少条评论记录
longitude  | 否       | 指定当前位置的经度, 范围为-180.0至180.0
latitude   | 否       | 指定当前位置的纬度, 范围为-90.0至90.0
max_distance | 否     | 获取指定max_distance距离内的直播列表
circle     | 否       | 整型，如果为1，只返回朋友圈内的所有living.

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","livings":[<living>, ...],"paginate_meta":<paginate_meta>}`, 其中`livings`为一数组，元素类型为living, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### living类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 一条直播记录的id
user_id              | 整型 | 表示创建该条记录的用户id
user_name            | 字符串 | 表示创建该条记录的用户名
user_avatar_url      | 整型 | 表示创建该条记录的用户头像url
title                | 字符串 | 标题
place                | 字符串 | 地点名称
price                | 字符串 | 价格
longitude            | 字符串 | 经度
latitude             | 字符串 | 纬度
distance             | 浮点数 | 与当前位置的距离, 单位为米
updated_at           | 字符串 | 更新时间
content              | 字符串 | 具体的内容
videos               | video类型的数组 | 视频相关信息, 如果没有视频，可能为[]
images               | image类型的数组 | 图片相关信息, 如果没有图片，可能为[]
likes                | like类型的数组  | 该条直播的点赞用户列表，如果没有，为[]
total_likes_count    | 整数            | 该条直播的所有点赞记录总数
comments             | comment类型的数组  | 该条视频的评论列表，如果没有，为[]
total_comments_count    | 整数            | 该条直播的所有评论记录总数


#### video类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条视频记录的id
url                  | 字符串 | 视频的url
thumb_url            | 字符串 | 该视频的thumb图片的url，用于显示缩略图

#### image类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条图片记录的id
url                  | 字符串 | 图片的url
thumb_url            | 字符串 | thumb图片的url，用于显示缩略图

#### like类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 一条点赞记录的id
user_id              | 整型 | 表示点赞的用户id
user_name            | 字符串 | 表示点赞的用户名

#### comment类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 一条评论记录的id
user_id              | 整型 | 发表评论的用户id
user_name            | 字符串 | 发表评论的用户名
reply_to_user_id              | 整型 | 回复某个用户的id, 当该条评论是回复某个用户时，才有该字段.
reply_to_user_name            | 字符串 | 回复某个用户的名称, 当该条评论是回复某个用户时，才有该字段.


#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数

### 对于每条直播记录中的点赞用户列表和评论列表，目前是缺省最多返回20条，这个值可以通过per_like_page和per_comment_page指定, 如果要取更多的数据，操作如下:

  1. 对于点赞列表，可以调用获取某条直播的点赞用户列表api，即`curl --request GET http://localhost:3000/api/v1/livings/1/likes?page=2&per_page=20`, 具体的page值可以基于total_likes_count和per_like_page算出.

  2. 对于评论列表，可以调用获取某条直播的评论列表api，即`curl --request GET http://localhost:3000/api/v1/livings/1/comments?page=2&per_page=20`, 具体的page值可以基于total_comments_count和per_comment_page算出.

## 添加一个直播记录

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"title":"hello"
          "place":"地点名称",
          "price":"35.5",
          "longitude":"12.5",
          "latitude":"234.6",
          "videos_attributes":[
            {"file":"视频文件数据"},
            {"file":"视频文件数据"}
            ]
          }'
     http://localhost:3000/api/v1/livings
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/livings`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
title      | 是      | 标题
place      | 是      | 地点名称
price      | 是      | 价格
content    | 否      | 详细内容
longitude  | 是      | 经度, 范围为-180.0至180.0
latitude   | 是      | 纬度, 范围为-90.0至90.0
videos_attributes | 否      | 上传的视频数据
images_attributes | 否      | 上传的图片数据


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 更新一个直播记录信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"title":"another title", "longitude":"55.2","latitude":"66.8"}'
     http://localhost:3000/api/v1/livings/2
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/livings/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条直播记录的id
title      | 是       | 标题
place      | 是       | 地点名称
price      | 是       | 价格
longitude  | 是       | 经度, 范围为-180.0至180.0
latitude   | 是       | 纬度, 范围为-90.0至90.0
videos_attributes | 否      | 上传的视频数据
images_attributes | 否      | 上传的图片数据


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 删除一个直播记录中的视频

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"videos_attributes":[{"id":1, "_destroy":1}]}'
     http://localhost:3000/api/v1/livings/2
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/livings/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条直播记录的id
videos_attributes | 是 | 为一个要删除的视频信息数组, 数组中每一个元素类型为["id":视频id,"_destroy":1]



### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


## 删除一条直播记录

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/livings/2
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/livings/<id>`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条直播记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取一条指定id的直播记录信息

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/livings/2
```

> 返回:

```json
{ "result":1,
  "video":
    {"id":2,
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":"32.5",
     "latitude":"62.8",
     "content":"adfasdf",
     "updated_at":"2016-04-20 14:49:56",
     "videos":[
        {"url":"http://115.29.110.82/public/uploads/sample.mp4",
         "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
         "id":1}]}}
```

### HTTP请求

`GET /api/v1/livings/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条直播记录的id
longitude  | 否       | 指定当前位置的经度, 范围为-180.0至180.0
latitude   | 否       | 指定当前位置的纬度, 范围为-90.0至90.0


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"living":<living>}`, 其中`living`为一直播类型的记录
失败  | `{"result":0,"error":"错误原因"}`

## 获取指定用户id的直播的列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/livings/of_user/2
```

> 返回:

```json
{ "result":1,
  "livings":[
    {"id":1,
     "user_id":2,
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":"32.5",
     "latitude":"62.8",
     "distance":110,
     "updated_at":"2016-04-20 14:49:56",
     "videos":[{"url":"http://115.29.110.82/public/uploads/sample.mp4",
                "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
                "id":2}]},
     ...],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```

### HTTP请求

`GET /api/v1/livings/of_user/:user_id`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
user_id    | 是       | 指定用户id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","livings":[<living>, ...],"paginate_meta":<paginate_meta>}`, 其中`livings`为一数组，元素类型为living, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

## 删除所有直播记录

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/livings/reset
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/livings/reset`

### DELETE请求参数
无

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取某一条直播的点赞用户列表
> 调用实例:

```shell

curl --request GET  http://localhost:3000/api/v1/livings/1/likes


> 返回:

```json
{ "result":1,
  "likes":[
    {"id":1,
     "user_id":2,
     "user_name":"ggg"},
    {"id":2,
     "user_id":3,
     "user_name":"www"},
     ...],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```

### HTTP请求

`GET /api/v1/livings/<id>/likes`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 直播记录id
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","likes":[<like>, ...],"paginate_meta":<paginate_meta>}`, 其中`likes`为一数组，元素类型为like, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`


## 给某一个直播记录点赞 

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     http://localhost:3000/api/v1/livings/1/likes
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/livings/<id>/likes`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条直播记录的id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

注意: 如果调用该请求进行多次点赞，只有第一次有效.

## 删除一个直播记录的点赞

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/livings/likes/1
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/livings/likes/<id>`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条点赞记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取某一条直播的评论列表

> 调用实例:

```shell

curl --request GET  http://localhost:3000/api/v1/livings/1/comments


> 返回:

```json
{ "result":1,
  "comments":[
    {"id":1,
     "user_id":2,
     "user_name":"ggg",
     "content": "hello"},
    {"id":2,
     "user_id":3,
     "user_name":"www",
     "content": "world",
     "reply_to_user_id": 1,
     "reply_to_user_name": "ggg"},
     ...],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```

### HTTP请求

`GET /api/v1/livings/<id>/comments`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 直播记录id
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","comments":[<comment>, ...],"paginate_meta":<paginate_meta>}`, 其中`comments`为一数组，元素类型为comment, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

## 给某一个直播记录添加评论 

> 调用实例:

```shell

1. 添加评论

curl -H 'Content-Type:application/json'
     --request POST
     -d '{"content":"hello"}'
     http://localhost:3000/api/v1/livings/1/comments

2. 回复某个用户评论

curl -H 'Content-Type:application/json'
     --request POST
     -d '{"content":"hello", "reply_to_user_id":2}'
     http://localhost:3000/api/v1/livings/1/comments

```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/livings/<id>/comments`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
content    | 是      | 评论内容 
reply_to_user_id   | 否      | 回复某个用户的id 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


## 删除一个直播记录的评论

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/livings/comments/1
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/livings/comments/<id>`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条评论记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`
