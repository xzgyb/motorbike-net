# Create baidu map control.
createBMap = (container) ->
    map = new BMap.Map(container)
    map.addControl(new BMap.NavigationControl())
    map.addControl(new BMap.ScaleControl())
    map.enableScrollWheelZoom()
    return map

# Display bike location map.
displayBikeLocationMap = (container, userName, longitude, latitude) ->
    map = createBMap(container)

    point = new BMap.Point(longitude, latitude)
    marker = new BMap.Marker(point)
    label = new BMap.Label(userName + "的位置",
                           {offset: new BMap.Size(-30, 30)})
    label.setStyle(
           color: "rgb(255,65,54)"
           fontWeight: "bold"
           fontSize: "18px"
           borderStyle: "none")

    marker.setLabel(label)
    map.addOverlay(marker)
    map.centerAndZoom(point, 19)

# Display bike track map.
displayBikeTrackMap = (container, locationPoints) ->
    map = createBMap(container)

    points = new Array()
    lastPoint = null

    for locationPoint in locationPoints
        point = new BMap.Point(locationPoint[0], locationPoint[1])
        lastPoint = point
        points.push(point)

    polyline = new BMap.Polyline(points, 
        strokeColor: "#FF264F",
        strokeWeight: 4,
        strokeOpacity: 0.5)

    map.addOverlay(polyline)
    map.centerAndZoom(lastPoint, 19)

    $elem = $(".BMap_mask")
    map.panBy($elem.width() / 2, $elem.height() / 2)

# Display maps both.
displayMaps = ->
  # Default display bike location map.
  displayBikeLocationMap("bike-location-map", gon.userName, gon.longitude, gon.latitude)

  displayBikeTrackMap("bike-track-map", gon.travelTrackHistories)

# Create map control and set event handlers.
$ ->
  mapHeight = window.innerHeight - 200 
  $("#bike-location-map").height(mapHeight)
  $("#bike-track-map").height(mapHeight)

  displayMaps()
