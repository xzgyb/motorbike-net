# 事件 

## 获取事件的列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/events?start_at=2016-08-08%2012:00:00
```

> 返回:

```json
{ "result":1,
  "events":[
    {"id":1,
     "title":"example title",
     "place":"example place",
     "longitude":"32.5",
     "latitude":"62.8",
     "type":3,
     ...],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```

### HTTP请求

`GET /api/v1/events`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
start_at   | 否       | 指定起始时间 如2016-08-08 12:00:00的形式 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","events":[<event>, ...],"paginate_meta":<paginate_meta>}`, 其中`events`为一数组，元素类型为event, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### event类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 一条记录的id
title                | 字符串 | 标题
content              | 字符串 | 备注 
place                | 字符串 | 地点名称
longitude            | 字符串 | 经度
latitude             | 字符串 | 纬度
image_url            | 字符串 | 图片的url, 如果是event类型，则为空
start_at             | 字符串 | 开始时间
end_at               | 字符串 | 结束时间
type                 | 整型 | 0:  表示活动(activity), 1: 表示直播(living), 2:表示捎东西(take_along_something), 3: 表示事件(event)
action_id            | 整型 | 如果type是0, 1, 2, action_id表示相关类型的id.

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数


## 添加一个事件记录

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"title":"hello"
          "place":"地点名称",
          "content":"sdfsdf",
          "longitude":"12.5",
          "latitude":"234.6",
          "start_at": "2016-05-01 12:00:50",
          "end_at": "2016-05-04 18:30:00",
          }'
     http://localhost:3000/api/v1/events
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/events`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
title      | 是      | 标题
place      | 是      | 地点名称
content    | 否      | 备注 
longitude  | 是      | 经度, 范围为-180.0至180.0
latitude   | 是      | 纬度, 范围为-90.0至90.0
start_at   | 是      | 开始时间
end_at     | 是      | 结束时间


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 更新一个事件记录信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"title":"another title", "longitude":"55.2", "latitude":"66.8"}'
     http://localhost:3000/api/v1/events/1
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/events/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条事件记录的id
title      | 是       | 标题
place      | 是       | 地点名称
content    | 否      | 备注 
longitude  | 是       | 经度, 范围为-180.0至180.0
latitude   | 是       | 纬度, 范围为-90.0至90.0
start_at   | 是       | 开始时间
end_at     | 是       | 结束时间


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


## 删除一条事件记录

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/events/1
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/events/<id>`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条事件记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取一条指定id的事件记录信息

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/events/1
```

> 返回:

```json
{ "result":1,
  "event":
    {"id":1,
     "title":"example title",
     "place":"example place",
     "longitude":"32.5",
     "latitude":"62.8",
     "content":"hello",
     "start_at":"2016-04-18 14:49:56",
     "end_at":"2016-04-19 00:49:56",
     "image_url": "",
```

### HTTP请求

`GET /api/v1/events/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条事件记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"event":<event>}`, 其中`event`为一事件类型的记录
失败  | `{"result":0,"error":"错误原因"}`
