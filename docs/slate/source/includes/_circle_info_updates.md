# 好友圈子实时更新

### 关于App端好友的活动，直播，捎东西等行为的实时更新实现

APP初始启动时可以调用`获取全部行为的列表api, 即GET /api/v1/actions`, 将得到的数据显示在界面上， 然后调用`圈子内好友行为实时更新`功能，进行界面的实时显示.

### 关于好友的圈子内好友行为实时更新实现

在启动时可以调用`获取好友列表api, 即GET /api/v1/friends`， 然后调用`圈子内好友位置实时更新`功能，进行界面的实时显示.

## 好友圈子内行为实时更新

当圈子内好友发布活动，直播，捎东西等，通过该功能，app端可以得到实时通知， 另外当好友更新，删除相应记录时，app端也会实时得到通知。

> 调用实例:

```java
URI uri = new URI("ws://115.29.110.82/cable");
Consumer.Options options = new Consumer.Options();

final Map<String, String> headers = new HashMap();
headers.put("Authorization", "Bearer " + accessToken);

options.headers      = headers;
options.reconnection = true;

mConsumer = Cable.createConsumer(uri, options);

Channel actionChannel = new Channel("ActionChannel");

mActionSubscription = mConsumer.getSubscriptions().create(actionChannel);

mActionSubscription.onReceived(new Subscription.ReceivedCallback() {
    @Override
    public void call(JsonElement data) {
        // data["action"] 即为实时更新的内容
    }
});

mConsumer.open();
```

> 当好友添加活动，捎东西，直播时，mActionSubscription.onReceived会被调用，data为实时更新的内容，如下:

```json
{"action": {
 "id":1,
 "user_id":2,
 "type":0,
 "longitude":"33.5",
 "latitude":"44.8",
 "status":0}
}
```

### 通道名称

'ActionChannel'

### 请求参数

参数名 | 是否必需 | 描述
-------|----------|------
accessToken  | 是       | oauth access token

### 实时更新的data字段

名称    | 类型      | 描述
-------|----------|------
id      | 整型    | 该条action的id
user_id | 整型     | 创建该条action的用户id
longitude|字符串    | 经度
latitude |字符串    | 纬度
type    | 整型 |该条action的类型， 0:  表示活动(activity), 1: 表示直播(living), 2:表示捎东西(take_along_something)
status  | 整数      | 该条action的状态, 0为添加, 1为删除, 2为更新.

## 圈子内好友位置实时更新

当圈子内好友位置发生变更时, app端可以得到实时通知.

> 调用实例:

```java
URI uri = new URI("ws://115.29.110.82/cable");
Consumer.Options options = new Consumer.Options();

final Map<String, String> headers = new HashMap();
headers.put("Authorization", "Bearer " + accessToken);

options.headers      = headers;
options.reconnection = true;

mConsumer = Cable.createConsumer(uri, options);

Channel friendLocationChannel = new Channel("FriendLocationChannel");

mFriendLocationSubscription = mConsumer.getSubscriptions().create(friendLocationChannel);

mFriendLocationSubscription.onReceived(new Subscription.ReceivedCallback() {
    @Override
    public void call(JsonElement data) {
        // data["friend_location"] 即为好友位置的实时更新
    }
});

mConsumer.open();
```

> 当好友位置变更时，mFriendLocationSubscription.onReceived会被调用，data为实时更新的内容，如下:

```json
{"friend_location":{
  "user_id":2,
  "longitude":"33.5",
  "latitude":"44.8"
  }
}
```

### 通道名称

'FriendLocationChannel'

### 请求参数

参数名 | 是否必需 | 描述
-------|----------|------
accessToken  | 是       | oauth access token

### 实时更新的data字段

名称    | 类型      | 描述
-------|----------|------
user_id  | 整型    | 好友的用户id
longitude| 字符串    | 好友位置的经度
latitude  | 字符串   | 好友位置的纬度
