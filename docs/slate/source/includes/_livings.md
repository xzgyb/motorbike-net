# 直播

## 获取直播的列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/livings
```

> 返回:

```json
{ "result":1,
  "livings":[
    {"id":"57148394495576297f2d30f7",
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "coordinates":[32.5,62.8],
     "updated_at":"2016-04-20 14:49:56",
     "videos":[{"url":"http://115.29.110.82/public/uploads/sample.mp4",
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

`GET /api/v1/livings`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","livings":[<living>, ...],"paginate_meta":<paginate_meta>}`, 其中`livings`为一数组，元素类型为living, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### living类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条直播记录的id
title                | 字符串 | 标题
place                | 字符串 | 地点名称
price                | 字符串 | 价格
coordinates          | 浮点数数组 | [经度, 纬度]
updated_at           | 字符串 | 更新时间
content              | 字符串 | 具体的内容
videos               | video类型的数组 | 视频相关信息

#### video类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条视频记录的id
url                  | 字符串 | 视频的url
thumb_url            | 字符串 | 该视频的thumb图片的url，用于显示缩略图

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数


## 添加一个直播记录

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"title":"hello"
          "place":"地点名称",
          "price":"35.5,",
          "coordinates":[12.5,234.6],
          "videos_attributes":[
            "file":"视频文件数据",
            "file":"视频文件数据"
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
coordinates| 是      | [经度, 纬度]
videos_attributes | 是      | 上传的视频数据


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
     -d '{"title":"another title", "coordinates":[55.2,66.8]}'
     http://localhost:3000/api/v1/livings/57148394495576297f2d30f7
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
coordinates| 是       | [经度, 纬度]
videos_attributes | 是      | 上传的视频数据


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
     -d '{"videos_attributes":[{"id":"57148394495576297f2d30f6", "_destroy":1}]}'
     http://localhost:3000/api/v1/livings/57148394495576297f2d30f7
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
curl --request DELETE http://localhost:3000/api/v1/livings/57148394495576297f2d30f7
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
curl --request GET http://localhost:3000/api/v1/livings/57148394495576297f2d30f7
```

> 返回:

```json
{ "result":1,
  "video":
    {"id":"57148394495576297f2d30f7",
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "coordinates":[32.5,62.8],
     "content":"",
     "updated_at":"2016-04-20 14:49:56",
     "videos":[
        {"url":"http://115.29.110.82/public/uploads/sample.mp4",
         "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
         "id":"57148394495576297f2d30f6"}]}}
```

### HTTP请求

`GET /api/v1/livings/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条直播记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"living":<living>}`, 其中`living`为一直播类型的记录
失败  | `{"result":0,"error":"错误原因"}`
