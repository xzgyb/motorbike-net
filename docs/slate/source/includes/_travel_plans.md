# 出行计划

## 获取登录用户的出行计划列表 

> 调用实例:

```shell
ccurl --request GET  http://localhost:3000/api/v1/travel_plans
```

> 返回:

```json
{"result":1,
 "travel_plans":
     [{"id":"5667e1dde54396160e00000b",
       "content":"11123asdfasfasdfasf",
       "passing_locations":[[115, 12.0],[34,56]],
       "destination_location":[118.28,55.22],
       "status":1,
       "start_off_time":"2015-12-12 03:00:00"}]}
```

### HTTP请求

`GET /api/v1/travel_plans`

### 请求参数

无

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","travel_plans":[<travel_plan>, ...]}`, 其中`travel_plans`为一数组，元素类型为travel_plan
失败  | `{"result":0,"error":"错误原因"}`

#### travel_plan类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条出行计划记录的id
content              | 字符串 | 出行计划的内容
passing_locations    | 数组   | 途经地的坐标数组，元素类型为[经度,纬度]的数组. 经度，纬度为浮点数。如[[115,12.0],[34,56]]. 
destination_location | 数组   | 目的地的经纬度数组，如[118.28,55.22]
status               | 整型   | 出行计划状态 
start_off_time       | 字符串 | 出发时间 

## 为当前登录用户创建一条出行计划 

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"content":"hello","passing_locations":[[12,3],[23,5]],
          "destination_location":[23.35,18.2],status:1,
          "start_off_time":"2015-12-30 08:30:00"}'
     http://localhost:3000/api/v1/travel_plans
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/travel_plans`

### POST请求参数

名称               | 类型   | 描述
---------------------|--------|------
content              | 字符串 | 出行计划的内容
passing_locations    | 数组   | 途经地的坐标数组，元素类型为[经度,纬度]的数组. 经度，纬度为浮点数。如[[115,12.0],[34,56]]. 
destination_location | 数组   | 目的地的经纬度数组，如[118.28,55.22]
status               | 整型   | 出行计划状态 
start_off_time       | 字符串 | 出发时间 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

## 为当前登录用户更新一条出行计划 

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"content":"hello", status:2}'
     http://localhost:3000/api/v1/travel_plans/5667e1dde54396160e00000b`
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/travel_plans/<id>`

### POST请求参数

名称                 | 是否必需 |  类型   | 描述
---------------------|----------|---------|------
id                   | 是       | 字符串  | 一条出行计划的id
content              | 否       | 字符串  | 出行计划的内容
passing_locations    | 否       |  数组   | 途经地的坐标数组，元素类型为[经度,纬度]的数组. 经度，纬度为浮点数。如[[115,12.0],[34,56]]. 
destination_location | 否       |  数组   | 目的地的经纬度数组，如[118.28,55.22]
status               | 否       |  整型   | 出行计划状态 
start_off_time       | 否       |  字符串 | 出发时间 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

## 为当前登录用户删除一条出行计划

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/travel_plans/5667e1dde54396160e00000b
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/travel_plans/<id>`

### POST请求参数

名称                 | 是否必需 |  类型   | 描述
---------------------|----------|---------|------
id                   | 是       | 字符串  | 一条出行计划的id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

## 为当前登录用户获取一条指定id的出行计划

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/travel_plans/5667e1dde54396160e00000b
```

> 返回:

```json
{ "result":1,
  "travel_plan":
   {"id":"5667e1dde54396160e00000b",
     "content":"11123asdfasfasdfasf",
     "passing_locations":[[115, 12.0],[34,56]],
     "destination_location":[118.28,55.22],
     "status":1,
     "start_off_time":"2015-12-12 03:00:00"}}
```

### HTTP请求

`GET /api/v1/travel_plans/<id>`

### 请求参数

名称                 | 是否必需 |  类型   | 描述
---------------------|----------|---------|------
id                   | 是       | 字符串  | 一条出行计划的id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`
