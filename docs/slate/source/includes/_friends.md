# 好友

## 获取好友列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/friends
```
> 返回:

```json
{"result":1,
 "friends":[
    {"id":1, "name":"amy", "avatar_url":"http://localhost:3000/images/a.png", longitude:33.5, latitude: 44.8},
    {"id":2, "name":"john", "avatar_url":"http://localhost:3000/images/b.png", longitude:33.5, latitude: 24.8},
    {"id":3, "name":"mike", "avatar_url":"http://localhost:3000/images/c.png", longitude:33.5, latitude: 34.8},
    {"id":4, "name":"peter", "avatar_url":"http://localhost:3000/images/d.png", longitude:33.5, latitude: 54.8}
  ],
 "paginate_meta": {"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":4}
}
```

### HTTP请求

`GET /api/v1/friends`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","friends":[<friend>, ...],"paginate_meta":<paginate_meta>}`, 其中`friends`为一数组，元素类型为friend, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### friend类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 好友的user id, 对应于users中的一条记录的id
name                 | 字符串 | 好友名称
avatar_url           | 字符串 | 好友的头像url
longitude            | 字符串 | 好友最新位置的经度
latitude             | 字符串 | 好友最新位置的纬度

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数


## 获取添加好友请求的列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/friends/pending
```

> 返回:

```json
{"result":1,
 "pending_friends":[
    {"id":1, "name":"amy"},
    {"id":2, "name":"john"},
    {"id":3, "name":"peter"}
  ],
 "paginate_meta": {"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":4}
}
```

### HTTP请求

`GET /api/v1/friends/pending`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","pending_friends":[<pending_friend>, ...],"paginate_meta":<paginate_meta>}`, 其中`pending_friends`为一数组，元素类型为pending_friend, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### pending_friend类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型 | 好友的user id, 对应于users中的一条记录的id
name                 | 字符串 | 好友名称

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数


## 添加一个好友

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"friend_id":2}'
     http://localhost:3000/api/v1/friends
```

> 返回:

```json
{"result":1}
```


### HTTP请求

`POST /api/v1/friends`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
friend_id  | 是      | 要加入好友的user id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

<aside class="warning">
注意:这个api调用后，friend_id对应的用户并不会成为当前用户的好友，需要friend_id对应的用户调用接受添加好友请求api才可以.
</aside>

## 接受添加好友的请求

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request POST
     -d '{"friend_id":2}'
     http://localhost:3000/api/v1/friends/accept
```

> 返回:

```json
{"result":1}
```


### HTTP请求

`POST /api/v1/friends/accept`

### POST请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
friend_id  | 是      | 加入好友请求的user id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

<aside class="warning">
注意:这个api调用后，friend_id对应的用户才能成为当前用户的好友.
</aside>


## 拒绝添加好友的请求

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request DELETE
     http://localhost:3000/api/v1/friends/deny/2
```

> 返回:

```json
{"result":1}
```


### HTTP请求

`DELETE /api/v1/friends/deny/:friend_id`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
friend_id  | 是      | 加入好友请求的user id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`


## 删除好友

> 调用实例:

```shell
curl -H 'Content-Type:application/json'
     --request DELETE
     http://localhost:3000/api/v1/friends/2
```

> 返回:

```json
{"result":1}
```


### HTTP请求

`DELETE /api/v1/friends/:friend_id`

### DELETE请求参数

参数名     | 是否必需 | 描述
-----------|---------|------
friend_id  | 是      | 好友的user id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 获取一个和指定用户id的共有的好友列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/friends/common_friends_with/2
```
> 返回:

```json
{"result":1,
 "friends":[
    {"id":1, "name":"amy", "avatar_url":"http://localhost:3000/images/a.png", longitude:33.5, latitude: 44.8},
    {"id":2, "name":"john", "avatar_url":"http://localhost:3000/images/b.png", longitude:33.5, latitude: 24.8},
    {"id":3, "name":"mike", "avatar_url":"http://localhost:3000/images/c.png", longitude:33.5, latitude: 34.8},
    {"id":4, "name":"peter", "avatar_url":"http://localhost:3000/images/d.png", longitude:33.5, latitude: 54.8}
  ],
 "paginate_meta": {"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":4}
}
```

### HTTP请求

`GET /api/v1/friends/common_friends_with/:user_id`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
user_id    | 是       | 指定用户id

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","friends":[<friend>, ...],"paginate_meta":<paginate_meta>}`, 其中`friends`为一数组，元素类型为friend, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

