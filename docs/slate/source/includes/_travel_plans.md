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
     [{"id":2,
       "content":"11123asdfasfasdfasf",
       "passing_locations":[{"longitude":"33.8","latitude":"42.5"},
                             {"longitude":"115","latitude":"12.0"}],
       "dest_loc_longitude":"118.28",
       "dest_loc_latitude":"55.22",
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
id                   | 整型 | 一条出行计划记录的id
content              | 字符串 | 出行计划的内容
passing_locations    | 数组   | 途经地的坐标数组，元素类型为passing_location.
dest_loc_longitude   | 字符串   | 目的地的经度
dest_loc_latitude    | 字符串   | 目的地的纬度
status               | 整型   | 出行计划状态 
start_off_time       | 字符串 | 出发时间 

#### passing_location类型说明

名称               | 类型   | 描述
---------------------|--------|------
longitude   | 字符串   | 经度
latitude    | 字符串   | 纬度

## 创建一条出行计划 

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"content":"hello",
          "passing_locations_attributes":[{"longitude":"33.8","latitude":"42.5"},
                                           {"longitude":"115","latitude":"12.0"}],
          "dest_loc_longitude":"23.35",
          "dest_loc_latitude":"18.2",
          status:1,
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
passing_locations_attributes    | 数组   | 途经地的坐标数组，元素类型为passing_location.
dest_loc_longitude | 字符串   | 目的地的经度
dest_loc_latitude | 字符串   | 目的地的纬度
status               | 整型   | 出行计划状态 
start_off_time       | 字符串 | 出发时间 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

## 更新一条出行计划 

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"content":"hello", status:2}'
     http://localhost:3000/api/v1/travel_plans/2`
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
id                   | 是       | 整型  | 一条出行计划的id
content              | 字符串 | 出行计划的内容
passing_locations_attributes    | 数组   | 途经地的坐标数组，元素类型为passing_location.
dest_loc_longitude | 字符串   | 目的地的经度
dest_loc_latitude | 字符串   | 目的地的纬度
status               | 整型   | 出行计划状态
start_off_time       | 字符串 | 出发时间

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

## 删除一条出行计划

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/travel_plans/1
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
id                   | 是       | 整型  | 一条出行计划的id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取一条指定id的出行计划

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/travel_plans/2
```

> 返回:

```json
{ "result":1,
  "travel_plan":
   {"id":2,
     "content":"11123asdfasfasdfasf",
     "passing_locations":[{"longitude":"33.8","latitude":"42.5"},
                           {"longitude":"115","latitude":"12.0"}],
     "dest_loc_longitude":"118.28",
     "dest_loc_latitude":"55.22",
     "status":1,
     "start_off_time":"2015-12-12 03:00:00"}}
```

### HTTP请求

`GET /api/v1/travel_plans/<id>`

### 请求参数

名称                 | 是否必需 |  类型   | 描述
---------------------|----------|---------|------
id                   | 是       | 整型  | 一条出行计划的id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1"}`
失败  | `{"result":0,"error":"错误原因"}`

