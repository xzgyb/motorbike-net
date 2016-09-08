# 活动

## 获取活动的列表
> 调用实例:

```shell

返回全部activity

curl --request GET  http://localhost:3000/api/v1/activities?longitude=32.3&latitude=62.9

返回朋友圈内的activity

curl --request GET  http://localhost:3000/api/v1/activities?circle=1&longitude=32.3&latitude=62.9
```

> 返回:

```json
{ "result":1,
  "activities":[
    {"id":1,
     "user_id":2,
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":"32.5",
     "latitude":"62.8",
     "distance":110,
     "updated_at":"2016-04-20 14:49:56",
     "start_at":"2016-04-18 14:49:56",
     "end_at":"2016-04-19 00:49:56",
     "images":[{"url":"http://115.29.110.82/public/uploads/sample.jpg",
                "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
                "id":"57148394495576297f2d30f6"}]},
     ...],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```

### HTTP请求

`GET /api/v1/activities`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
longitude  | 否       | 指定当前位置的经度, 范围为-180.0至180.0
latitude   | 否       | 指定当前位置的纬度, 范围为-90.0至90.0
max_distance | 否     | 获取指定max_distance距离内的活动列表
circle     | 否       | 整型，如果为1，只返回朋友圈内的所有activity.

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","activities":[<activity>, ...],"paginate_meta":<paginate_meta>}`, 其中`activities`为一数组，元素类型为activity, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### activity类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 一条活动记录的id
user_id              | 整型 | 表示创建该条记录的用户id
title                | 字符串 | 标题
place                | 字符串 | 地点名称
price                | 字符串 | 价格
longitude            | 字符串 | 经度
latitude             | 字符串 | 纬度
distance             | 浮点数 | 与当前位置的距离, 单位为米
updated_at           | 字符串 | 更新时间
start_at             | 字符串 | 开始时间
end_at               | 字符串 | 结束时间
content              | 字符串 | 具体的内容
images               | image类型的数组 | 图片相关信息， 如果没有图片，为[]

#### image类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 一条图片记录的id
url                  | 字符串 | 图片的url
thumb_url            | 字符串 | thumb图片的url，用于显示缩略图

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数


## 添加一个活动记录

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"title":"hello"
          "place":"地点名称",
          "price":"35.5",
          "content":"sdfsdf",
          "longitude":"12.5",
          "latitude":"234.6",
          "start_at": "2016-05-01 12:00:50",
          "end_at": "2016-05-04 18:30:00",
          "images_attributes":[
            {"file":"图片文件数据"},
            {"file":"图片文件数据"}
            ],
          "participations_attributes":[
            {"user_id":3},
            {"user_id":4}
           ],
          }'
     http://localhost:3000/api/v1/activities
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/activities`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
title      | 是      | 标题
place      | 是      | 地点名称
price      | 是      | 价格
content    | 否      | 详细内容
longitude  | 是      | 经度, 范围为-180.0至180.0
latitude   | 是      | 纬度, 范围为-90.0至90.0
start_at   | 是      | 开始时间
end_at     | 是      | 结束时间
images_attributes | 否      | 上传的图片数据
participations_attributes | 否 | 活动参与者的id数组


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 更新一个活动记录信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"title":"another title", "longitude":"55.2", "latitude":"66.8"}'
     http://localhost:3000/api/v1/activities/1
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/activities/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条活动记录的id
title      | 是       | 标题
place      | 是       | 地点名称
price      | 是       | 价格
content    | 否      | 详细内容
longitude  | 是       | 经度, 范围为-180.0至180.0
latitude   | 是       | 纬度, 范围为-90.0至90.0
start_at   | 是       | 开始时间
end_at     | 是       | 结束时间
images_attributes | 否 | 上传的图片数据
participations_attributes | 否 | 活动参与者的id数组


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 删除一个活动记录中的图片

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"images_attributes":[{"id":"1", "_destroy":1}]}'
     http://localhost:3000/api/v1/activities/1
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/activities/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条活动记录的id
images_attributes | 是 | 为一个要删除的图片信息数组, 数组中每一个元素类型为["id":图片id,"_destroy":1]



### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


## 删除一条活动记录

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/activities/1
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/activities/<id>`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条活动记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取一条指定id的活动记录信息

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/activities/1
```

> 返回:

```json
{ "result":1,
  "activity":
    {"id":1,
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":"32.5",
     "latitude":"62.8",
     "content":"",
     "updated_at":"2016-04-20 14:49:56",
     "start_at":"2016-04-18 14:49:56",
     "end_at":"2016-04-19 00:49:56",
     "organizer":{
        "id":2,
        "avatar_url":"http://115.29.110.82/uploads/user/avatar/8743/sample.jpg", 
        "name":"name5", 
        "title":"3级飞车党", 
        "level":"LV.3"},
      "participations": [
          {"id":511, 
           "user_id": 8744, 
            "user_avatar_url":"http://115.29.110.82/uploads/user/avatar/8744/sample.jpg", 
            "user_name":"gyb",
            "activity_id":1}, 
          {"id":512, 
           "user_id":8745, 
           "user_avatar_url":"http://115.29.110.82/uploads/user/avatar/8745/sample.jpg",
           "user_name":"ww",
           "activity_id":1}
       ],
     "images":[
        {"url":"http://115.29.110.82/public/uploads/sample.jpg",
         "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
         "id":"57148394495576297f2d30f6"}]}}
```

### HTTP请求

`GET /api/v1/activities/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条活动记录的id
longitude  | 否       | 指定当前位置的经度, 范围为-180.0至180.0
latitude   | 否       | 指定当前位置的纬度, 范围为-90.0至90.0


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"activity":<activity>}`, 其中`activity`为activity_detail类型的记录
失败  | `{"result":0,"error":"错误原因"}`

#### activity_detail类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 一条活动记录的id
user_id              | 整型 | 表示创建该条记录的用户id
title                | 字符串 | 标题
place                | 字符串 | 地点名称
price                | 字符串 | 价格
longitude            | 字符串 | 经度
latitude             | 字符串 | 纬度
distance             | 浮点数 | 与当前位置的距离, 单位为米
updated_at           | 字符串 | 更新时间
start_at             | 字符串 | 开始时间
end_at               | 字符串 | 结束时间
content              | 字符串 | 具体的内容
images               | image类型的数组 | 图片相关信息， 如果没有图片，为[]
organizer            | organizer类型   | 为该活动的组织者信息
participations       | participation类型的数组 | 为该活动的参与者信息的数组

#### organizer类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型   | 用户id
name                 | 字符串 | 用户名称
title                | 字符串 | 用户头衔
level                | 字符串 | 用户级别 
avatar_url           | 字符串 | 用户头像url

#### participation类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型   | 该participation记录id
user_id              | 整型   | 该参与者用户id
user_name            | 字符串 | 该参与者用户名称
user_avatar_url      | 字符串 | 该参与者用户头像url
activity_id          | 整型   | 参与的活动id

## 获取指定用户id活动的列表

> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/activities/of_user/2
```

> 返回:

```json
{ "result":1,
  "activities":[
    {"id":1,
     "user_id":2,
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":"32.5",
     "latitude":"62.8",
     "distance":110,
     "updated_at":"2016-04-20 14:49:56",
     "start_at":"2016-04-18 14:49:56",
     "end_at":"2016-04-19 00:49:56",
     "images":[{"url":"http://115.29.110.82/public/uploads/sample.jpg",
                "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
                "id":"57148394495576297f2d30f6"}]},
     ...],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```

### HTTP请求

`GET /api/v1/activities/of_user/:user_id`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
user_id    | 是       | 指定用户id 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","activities":[<activity>, ...],"paginate_meta":<paginate_meta>}`, 其中`activities`为一数组，元素类型为activity, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

## 报名参加活动 

> 调用实例:

```shell
curl --request PUT http://localhost:3000/api/v1/activities/1/participate
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/activities/<id>/participate`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 报名参加的活动记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 删除所有活动记录

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/activities/reset
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/activities/reset`

### DELETE请求参数
无

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`
