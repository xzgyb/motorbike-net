# Create baidu map control.
createBMap = (container) ->
    map = new BMap.Map(container)
    map.addControl(new BMap.NavigationControl())
    map.addControl(new BMap.ScaleControl())
    map.enableScrollWheelZoom()
    return map

# Display bike location map.
displayBikeLocationMap = (map, userName, longitude, latitude) ->
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
displayBikeTrackMap = (map, locationPoints) ->
    points = new Array(locationPoints.length)
    lastPoint = null

    for locationPoint in locationPoints
        point = new BMap.Point(locationPoint[0], locationPoint[1])
        lastPoint = point
        points.push(point)

    polyline = new BMap.Polyline(points, 
        strokeColor: "blue",
        strokeWeight: 6,
        strokeOpacity: 0.5)

    map.addOverlay(polyline)
    map.centerAndZoom(lastPoint, 19)
       
# Create map control and set event handlers.
$ ->
  mapHeight = window.innerHeight - 200 
  $("#bike-location-map").height(mapHeight)
  $("#bike-track-map").height(mapHeight)

  bikeLocationMap = createBMap("bike-location-map")
  bikeTrackMap = createBMap("bike-track-map")

  #displayBikeTrackMap(bikeLocationMap, [
  #        [123.474151, 41.769966]
  #        [123.477882, 41.770017]
  #      ])

  displayBikeLocationMap(bikeLocationMap, gon.user_name, gon.longitude, gon.latitude)

  $('a[href="#map-location-tab"]').on 'show.bs.tab', ->

  $('a[href="#map-track-tab"]').on 'show.bs.tab', ->
