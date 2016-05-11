App.action = App.cable.subscriptions.create "ActionChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    alert(data['msg'])

  sendmsg: (msg) ->
    @perform("sendmsg", msg: msg)
