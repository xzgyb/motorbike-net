# 捎东西

## 获取一个捎东西的列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/take_along_somethings?longitude=32.3&latitude=62.9
```

> 返回:

```json
{ "result":1,
  "take_along_somethings":[
    {"id":"57148394495576297f2d30f7",
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":32.5,
     "latitude":62.8,
     "distance":110,
     "updated_at":"2016-04-20 14:49:56",
     "start_at":"2016-04-18 14:49:56",
     "end_at":"2016-04-19 00:49:56",
     "sender":{
       "id":"1123123345345435",
       "name":"ggg",
       "phone":"13811111111",
       "adress":"sgsfgsdfgsfg"
     },
     "receiver":{
       "id":"11233123345345435",
       "name":"fff",
       "phone":"13911111111",
       "adress":"sgsfgsdfgsfg"
     },
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

`GET /api/v1/take_along_somethings`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
longitude  | 否       | 指定当前位置的经度
latitude   | 否       | 指定当前位置的纬度
max_distance | 否     | 获取指定max_distance距离内的捎东西列表

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","take_along_somethings":[<take_along_something>, ...],"paginate_meta":<paginate_meta>}`, 其中`take_along_somethings`为一数组，元素类型为take_along_something, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### take_along_something类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条捎东西记录的id
user_id              | 字符串 | 表示创建该条记录的用户id 
title                | 字符串 | 标题
place                | 字符串 | 地点名称
price                | 字符串 | 价格
longitude            | 浮点数 | 经度
latitude             | 浮点数 | 纬度
distance             | 整数   | 与当前位置的距离, 单位为米
updated_at           | 字符串 | 更新时间
start_at             | 字符串 | 开始时间
end_at               | 字符串 | 结束时间
content              | 字符串 | 具体的内容
images               | image类型的数组 | 图片相关信息
sender               | sender类型的对象 | 发件人信息, 可能为null
receiver             | receiver类型的对象 | 收件人信息, 可能为null

#### image类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条图片记录的id
url                  | 字符串 | 图片的url
thumb_url            | 字符串 | thumb图片的url，用于显示缩略图

#### sender类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 发件人记录的id
name                 | 字符串 | 发件人姓名
phone                | 字符串 | 发件人电话
address              | 字符串 | 发件人地址

#### receiver类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 收件人记录的id
name                 | 字符串 | 收件人姓名
phone                | 字符串 | 收件人电话
address              | 字符串 | 收件人地址

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数


## 添加一个捎东西记录

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"title":"hello"
          "place":"地点名称",
          "price":"35.5",
          "longitude":12.5,
          "latitude":234.6,
          "start_at": "2016-05-01 12:00:50",
          "end_at": "2016-05-04 18:30:00",
          "sender_attributes":{
             "name":"ggg",
             "phone":"13811111111",
             "adress":"sgsfgsdfgsfg"
           },
           "receiver_attributes":{
             "name":"fff",
             "phone":"13911111111",
             "adress":"sgsfgsdfgsfg"
           },
          "images_attributes":[
            "file":"图片文件数据",
            "file":"图片文件数据"
            ]
          }'
     http://localhost:3000/api/v1/take_along_somethings
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/take_along_somethings`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
title      | 是      | 标题
place      | 是      | 地点名称
price      | 是      | 价格
longitude  | 是      | 经度
latitude   | 是      | 纬度
start_at   | 是      | 开始时间
end_at     | 是      | 结束时间
images_attributes | 是 | 上传的图片数据
sender_attributes | 否 | 发件人信息
receiver_attributes | 否 | 收件人信息

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 更新一个捎东西记录信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"title":"another title",
          "longitude":55.2,
          "latitude":66.8,
          "sender_attributes":{
             "id":"1123123345345435"
             "name":"ggg1232",
             "phone":"1381111411"}
          }'
     http://localhost:3000/api/v1/take_along_somethings/57148394495576297f2d30f7
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/take_along_somethings/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条捎东西记录的id
title      | 是       | 标题
place      | 是       | 地点名称
price      | 是       | 价格
longitude  | 是       | 经度
latitude   | 是       | 纬度
start_at   | 是       | 开始时间
end_at     | 是       | 结束时间
images_attributes | 是 | 上传的图片数据
sender_attributes | 否 | 发件人信息
receiver_attributes | 否 | 收件人信息


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 删除一个捎东西记录中的图片

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"images_attributes":[{"id":"57148394495576297f2d30f6", "_destroy":1}]}'
     http://localhost:3000/api/v1/take_along_somethings/57148394495576297f2d30f7
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/take_along_somethings/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条捎东西记录的id
images_attributes | 是 | 为一个要删除的图片信息数组, 数组中每一个元素类型为["id":图片id,"_destroy":1]



### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


## 删除一条捎东西记录

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/take_along_somethings/57148394495576297f2d30f7
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/take_along_somethings/<id>`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条捎东西记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取一条指定id的捎东西记录信息

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/take_along_somethings/57148394495576297f2d30f7
```

> 返回:

```json
{ "result":1,
  "take_along_something":
    {"id":"57148394495576297f2d30f7",
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":32.5,
     "latitude":62.8,
     "content":"",
     "updated_at":"2016-04-20 14:49:56",
     "start_at":"2016-04-18 14:49:56",
     "end_at":"2016-04-19 00:49:56",
     "sender":{
       "id":"1123123345345435",
       "name":"ggg",
       "phone":"13811111111",
       "adress":"sgsfgsdfgsfg"
     },
     "receiver":{
       "id":"11233123345345435",
       "name":"fff",
       "phone":"13911111111",
       "adress":"sgsfgsdfgsfg"
     },
     "images":[
        {"url":"http://115.29.110.82/public/uploads/sample.jpg",
         "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
         "id":"57148394495576297f2d30f6"}]}}
```

### HTTP请求

`GET /api/v1/take_along_somethings/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条捎东西记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"take_along_something":<take_along_something>}`, 其中`take_along_something`为一捎东西类型的记录
失败  | `{"result":0,"error":"错误原因"}`
