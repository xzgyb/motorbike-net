# 圈子发起的全部行为

## 获取全部行为的列表
> 调用实例:

```shell
curl --request GET  http://localhost:3000/api/v1/actions?longitude=32.3&latitude=62.9
```

> 返回:

```json
{ "result":1,
  "actions":[
    {"id":"57148394495576297f2d30f7",
     "type":"video",
     "title":"example title",
     "place":"example place",
     "price":"0.0",
     "longitude":32.5,
     "latitude":62.8,
     "distance":110,
     "updated_at":"2016-04-20 14:49:56",
     "videos":[{"url":"http://115.29.110.82/public/uploads/sample.mp4",
                "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
                "id":"57148394495576297f2d30f6"}]},
     {"id":"67148394495576297f2d30f7",
      "type":"activity",
      "title":"example title",
      "place":"example place",
      "price":"0.0",
      "longitude":32.5,
      "latitude":62.8,
      "distance":120,
      "updated_at":"2016-04-20 14:49:56",
      "start_at":"2016-04-18 14:49:56",
      "end_at":"2016-04-19 00:49:56",
      "images":[{"url":"http://115.29.110.82/public/uploads/sample.jpg",
                "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
                "id":"57148394495574597f2d30f6"}]},
     {"id":"77148394495576297f2d30f7",
      "type":"take_along_something",
      "title":"example title",
      "place":"example place",
      "price":"0.0",
      "longitude":32.5,
      "latitude":62.8,
      "distance":130,
      "updated_at":"2016-04-20 14:49:56",
      "start_at":"2016-04-18 14:49:56",
      "end_at":"2016-04-19 00:49:56",
      "images":[{"url":"http://115.29.110.82/public/uploads/sample.jpg",
                "thumb_url":"http://115.29.110.82/public/uploads/sample.jpg",
                "id":"57148394491274597f2d30f6"}]},
     ],

  "paginate_meta":{"current_page":1,
                   "next_page":null,
                   "prev_page":null,
                   "total_pages":1,
                   "total_count":17}
}
```


### HTTP请求

`GET /api/v1/actions`

### 请求参数

参数名     | 是否必需 | 描述
-----------|----------|------
page       | 否       | 要获取第几页数据
per_page   | 否       | 指定每页多少条记录
longitude  | 否       | 指定当前位置的经度
latitude   | 否       | 指定当前位置的纬度
max_distance | 否     | 获取指定max_distance距离内的行为列表

### 返回结果

结果  | 内容
------|--------------
成功  | `{"result":1","actions":[<action>, ...],"paginate_meta":<paginate_meta>}`, 其中`activities`为一数组，元素类型为action, paginate_meta为分页相关数据。
失败  | `{"result":0,"error":"错误原因"}`

#### action类型说明

名称               | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条action记录的id
type                 | 字符串 | activity: 表示活动, take_along_something: 表示捎东西, living: 表示直播
user_id              | 字符串 | 表示创建该条记录的用户id 
title                | 字符串 | 标题
place                | 字符串 | 地点名称
price                | 字符串 | 价格
longitude            | 浮点数 | 经度
latitude             | 浮点数 | 纬度
distance             | 整数   | 与当前位置的距离, 单位为米
updated_at           | 字符串 | 更新时间
start_at             | 字符串 | 开始时间, type为activity或take_along_something才有该字段
end_at               | 字符串 | 结束时间, type为activity或take_along_something才有该字段
content              | 字符串 | 具体的内容
images               | image类型的数组 | 图片相关信息 , type为activity或take_along_something才有该字段
videos               | videos类型的数组 | 视频相关信息, type为living才有该字段

#### image类型说明

名称                 | 类型   | 描述
---------------------|--------|------
id                   | 字符串 | 一条图片记录的id
url                  | 字符串 | 图片的url
thumb_url            | 字符串 | thumb图片的url，用于显示缩略图

#### video类型说明

名称                 | 类型   | 描述
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
