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
   [{"id":1,
     "name":"rensheng1234",
     "module_id":"123123123",
     "longitude":"112.5",
     "latitude":"318.5",
     "battery":"12.5",
     "travel_mileage":"0.0",
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
id                   | 整型 | 一条车辆信息记录的id
name                 | 字符串 | 车辆名称
module_id            | 字符串 | 模块id 
longitude            | 字符串 | 经度
latitude             | 字符串 | 纬度
battery              | 字符串 | 电量
travel_mileage       | 字符串 | 行驶里程数
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
     -d '{"longitude":"134.5", "latitude":"5", "diag_info":{"sdf":"234"}}'
     http://localhost:3000/api/v1/bikes/2
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
curl --request DELETE http://localhost:3000/api/v1/bikes/2
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
curl --request GET http://localhost:3000/api/v1/bikes/2
```

> 返回:

```json
{ "result":1,
  "bike":
   {"id":2,
     "name":"rensheng1234",
     "module_id":"123123123",
     "longitude":"112.5",
     "latitude":"318.5",
     "battery":"12.5",
     "travel_mileage":"0.0",
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
`curl --request GET http://localhost:3000/api/v1/bikes/2/locations
```

> 返回:

```json
{"result":1,
 "locations":
   [{"longitude":"12.5","latitude":"118.5"},
    {"longitude":"112.5","latitude":"318.5"}]}
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
     -d '{"longitude":"134.5", "latitude":"5", "diag_info":{"sdf":"234"}}'
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

## 电动车异常信息通知

当模块端调用上传电动车信息api的diag_info字段中，含有notify为1的键值时，表示车辆发生异常信息，网站端将把diag_info信息用短信形式发送给用户的手机, 同时通过BikeChannel通道通知app端.

### BikeChannel通道

通道名  | 含义
------|--------------
BikeChannel  | 电动车异常消息通知的通道名, 通知的内容为`{"bike":<bike_message>}`, bike为bike_message类型

### bike_message类型

名称               | 类型   | 描述
---------------------|--------|------
name                 | 字符串 | 电动车名称
status               | 整型   | 状态值，-1表示出现异常状态 
diag_info            | 字典类型 | 硬件模块传递的异常诊断信息，app端可以根据此内容进行界面显示. 
