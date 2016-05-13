# 车辆信息

## 获取登录用户的车辆信息

> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/bikes
```

> 返回:

```json
{ "result":1,
  "bikes":
   [{"id":"5673a4a8e5439637e1000000",
     "name":"rensheng1234",
     "module_id":"123123123",
     "longitude":112.5,
     "latitude":318.5,
     "battery":12.5,
     "travel_mileage":0.0,
     "diag_info":{"sdf":"234"}}]}
```

### HTTP请求

`GET /api/v1/bikes`

### 请求参数

无

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","bikes":[<bike>, ...]}`, 其中`bikes`为一数组，元素类型为bike
失败  | `{"result":0,"error":"错误原因"}`

#### bike类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条车辆信息记录的id
name                 | 字符串 | 车辆名称
module_id            | 字符串 | 模块id 
longitude            | 浮点数 | 经度
latitude             | 浮点数 | 纬度
battery              | 浮点数 | 电量
travel_mileage       | 浮点数 | 行驶里程数 
diag_info            | 哈希类型 | 车辆的诊断信息 

## 添加一个电动车信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"module_id":"2423424"
          "name":"moto1123"}'
     http://localhost:3000/api/v1/bikes
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`POST /api/v1/bikes`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
module_id  | 是       | 电动车的模块id
name       | 否       | 电动车的名称


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 更新一个电动车信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"longitude":134.5, "latitude":5, "diag_info":{"sdf":"234"}}'
     http://localhost:3000/api/v1/bikes/5673a4a8e5439637e1000000
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/bikes/<id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条车辆信息记录的id
module_id  | 否       | 模块id 
name       | 否       | 车辆名称
longitude  | 否       | 经度
latitude   | 否       | 纬度
battery    | 否       | 电量
travel_mileage | 否   | 行驶里程数 
diag_info  | 否       | 车辆的诊断信息 


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 删除一个电动车信息

> 调用实例:

```shell
curl --request DELETE http://localhost:3000/api/v1/bikes/5673a4a8e5439637e1000000
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`DELETE /api/v1/bikes/<id>`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条车辆信息记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取一条指定bike id的电动车信息

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/bikes/5673a4a8e5439637e1000000
```

> 返回:

```json
{ "result":1,
  "bike":
   {"id":"5673a4a8e5439637e1000000",
     "name":"rensheng1234",
     "module_id":"123123123",
     "longitude":112.5,
     "latitude":318.5,
     "battery":12.5,
     "travel_mileage":0.0,
     "diag_info":{"sdf":"234"}}
```

### HTTP请求

`GET /api/v1/bikes/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条车辆信息记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"bike":<bike>}`, 其中`bike`为一bike类型的记录，表示该条车辆信息
失败  | `{"result":0,"error":"错误原因"}`

## 获取指定的电动车行驶位置信息

> 调用实例:

```shell
`curl --request GET http://localhost:3000/api/v1/bikes/5673a4a8e5439637e1000000/locations
```

> 返回:

```json
{"result":1,
 "locations":
   [{"longitude":12.5,"latitude":118.5},
    {"longitude":112.5,"latitude":318.5}]}
```

### HTTP请求

`GET /api/v1/bikes/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条车辆信息记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"locations":[<location>,...]}`, 其中`locations`为一location类型的数组，表示电动车的行驶位置信息，每个元素的类型为[经度，纬度]
失败  | `{"result":0,"error":"错误原因"}`

## 上传一个指定模块id的电动车信息

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request PUT
     -d '{"longitude":134.5, "latitude":5, "diag_info":{"sdf":"234"}}'
     http://localhost:3000/api/v1/bikes/upload/123123123`
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/bikes/upload/<module_id>`

### PUT请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
module_id  | 是       | 模块id 
name       | 否       | 车辆名称
longitude  | 否       | 经度
latitude   | 否       | 纬度
battery    | 否       | 电量
travel_mileage | 否   | 行驶里程数 
diag_info  | 否       | 车辆的诊断信息 


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

