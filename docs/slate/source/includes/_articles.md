# 时尚资讯  

## 获取时尚资讯列表

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/articles
```

> 返回:

```json
{"result":1,
 "articles":[{"id":"56ea2129636239098ec5ff2a",
              "title":"终于，Xbox One 也加入到了 UWP 的队列",
              "title_image_url":"http://192.168.33.10:3000/uploads/article_images/thumb_201603171114442cea080064cbe6a897ed9fa0422d10ba.jpg",
              "updated_at":"2016-03-17 11:15:20"}]}
```

### HTTP请求

`GET /api/v1/articles`

### 请求参数

无


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"articles":[<article>,...]}`, 其中articles是article类型的数组，表示资讯列表
失败  | `{"result":0,"error":"错误原因"}`

#### article类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条资讯记录的id
title                | 字符串 | 资讯的标题
title_image_url      | 字符串 | 标题图片的url
updated_at           | 字符串 | 资讯的更新时间

## 获取一条时尚资讯

> 调用实例:

```shell
curl --request GET http://localhost:3000/api/v1/articles/56e9227d636239120278a400
```

> 返回:

```json
{"result":1,
 "article":{"id":"56e9227d636239120278a400",
            "title":"人生自古",
            "title_image_url":"http://192.168.33.10:3000/uploads/article_images/thumb_201603161708058cf67a34c9d6856396010586ca972790.jpg",
            "body":"...",
            "updated_at":"2016-03-17 09:57:28"}}
```

### HTTP请求

`GET /api/v1/articles/<id>`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
id         | 是       | 一条资讯记录的id


### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1,"article":<article>}`, 其中article是article类型加上body字段, 表示一条资讯信息, body表示文章的内容 
失败  | `{"result":0,"error":"错误原因"}`

