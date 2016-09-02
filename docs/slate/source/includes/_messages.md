# 消息 

## 获取消息的列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/messages
```

> 返回:

```json
{"result":1,
 "messages":[
  {"is_read":0, 
   "message_type":2,
   "order_take":{"id":384, 
                 "take_along_something_id":4,
                 "user_id":8811,
                 "user_avatar_url":"http://115.29.110.82/uploads/user/avatar/8811/sample.jpg", 
                 "user_name":"john"}
   },
  {"is_read":0, 
    "message_type":1, 
    "participation":{"id":524, 
                     "activity_id":3,
                     "user_id":8811, 
                     "user_avatar_url":"http://115.29.110.82/uploads/user/avatar/8811/sample.jpg", 
                     "user_name":"john"}
   }, 
   {"is_read":0, 
    "message_type":0, 
    "friendship":{"friend_id":8811, 
                  "friend_name":"john", 
                  "friend_avatar_url":"http://115.29.110.82/uploads/user/avatar/8811/sample.jpg",     
                  "accepted":0}}
   ], 
  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":3}
}
```

### HTTP请求

`GET /api/v1/messages`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
start_at   | 否       | 指定起始时间 如2016-08-08 12:00:00的形式 

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","messages":[<message>, ...],"paginate_meta":<paginate_meta>}`, 其中`messages`为一数组，元素类型为message, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### message类型说明

名称               | 类型   | 描述
---------------------|--------|------
is_read              | 整型   | 是否读过该消息, 1为读过, 0为没有读过, app端可以根据该值判断消息是否读过, 来进行界面的相应显示.
message_type         | 整型   | 该条消息的类型，如果为0，则为加好友请求消息，如果为1，则为某个好友参加当前用户发起的活动信息，如果为2,则为某个好友接单当前用户的捎东西信息。
friendship           | friendship类型 | 加好友请求信息，message_type为0才有该信息.
participation        | participation类型 | 参加活动信息，message_type为1才有该信息. 
order_take           | order_take类型 | 接单捎东西信息，message_type为2才有该信息. 

#### friendship类型说明

名称               | 类型   | 描述
---------------------|--------|------
friend_id            | 整型   | 好友id
friend_name          | 字符串 | 好友名称
friend_avatar_url    | 字符串 | 好友头像url
accepted             | 整型   | 表示是否接受好友添加请求，1为接受, 0为没有接受.

#### participation类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型   | 该participation记录id
user_id              | 整型   | 该参与者用户id
user_name            | 字符串 | 该参与者用户名称
user_avatar_url      | 字符串 | 该参与者用户头像url
activity_id          | 整型   | 参与的活动id

#### order_take类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 整型   | 该order_take记录id
user_id              | 整型   | 该接单人用户id
user_name            | 字符串 | 该接单人用户名称
user_avatar_url      | 字符串 | 该接单人用户头像url
take_along_someting_id | 整型 | 接单的捎东西记录id

#### paginate_meta类型说明

名称               | 类型   | 描述
---------------------|--------|------
current_page         | 整型   | 当前页面号
next_page            | 整型   | 下一个页面号，可能为null
prev_page            | 整型   | 前一个页面号, 可能为null
total_pages          | 整型   | 总共页面数
total_count          | 整型   | 总共记录数

## 获取未读的消息个数 

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/messages/unread_count
```

> 返回:

```json
{"result":1, "messages":{"unread_count":3}}
```

### HTTP请求

`GET /api/v1/messages/unread_count`

### GET请求参数
无


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1, "messages":{"unread_count":<count>}}`, 其中`unread_count`即未读消息个数 
失败  | `{"result":0,"error":"错误原因"}`

## 标识所有消息已读 

> 调用实例:

```shell
curl --request PUT http://localhost:3000/api/v1/messages/mark_as_read
```

> 返回:

```json
{"result":1}
```

### HTTP请求

`PUT /api/v1/messages/mark_as_read`

### PUT请求参数
无

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1}`
失败  | `{"result":0,"error":"错误原因"}`

## 消息通知

当产生新的消息时，网站会通知app端，使用MessagesChannel通道通知, 通知内容如下:
`{"messages":{"unread_count":3}}`, app端使用该信息可以实时得到未读消息个数, 并显示到界面上.

### MessagesChannel通道
通道名  | 含义
------|--------------

MessagesChannel  | 消息通知的通道名, 通知的内容为`{"messages":<messages_info>}`, messages为messages_info类型. 

### messages_info类型

名称               | 类型   | 描述
---------------------|--------|------
unread_count         | 整型   | 未读的消息个数 
