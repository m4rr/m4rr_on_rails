# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

base_url = 'images/map/'
font_weight = 'bold'
font_family = 'Roboto, Helvetica, sans-serif'
text_color = '#fff'
# //snazzymaps.com/style/42/apple-maps-esque
mapStyleMyFork = [{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"lightness":"65"}]},{"featureType":"administrative.locality","elementType":"all","stylers":[{"hue":"#2c2e33"},{"saturation":7},{"lightness":19},{"visibility":"on"}]},{"featureType":"landscape","elementType":"all","stylers":[{"hue":"#ffffff"},{"saturation":-100},{"lightness":100},{"visibility":"simplified"}]},{"featureType":"poi","elementType":"all","stylers":[{"hue":"#ffffff"},{"saturation":-100},{"lightness":100},{"visibility":"off"}]},{"featureType":"road","elementType":"geometry","stylers":[{"hue":"#008eff"},{"saturation":-93},{"lightness":31},{"visibility":"off"}]},{"featureType":"road","elementType":"labels","stylers":[{"hue":"#bbc0c4"},{"saturation":-93},{"lightness":31},{"visibility":"on"}]},{"featureType":"road.arterial","elementType":"labels","stylers":[{"hue":"#bbc0c4"},{"saturation":-93},{"lightness":-2},{"visibility":"simplified"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"hue":"#e9ebed"},{"saturation":-90},{"lightness":-8},{"visibility":"simplified"}]},{"featureType":"transit","elementType":"all","stylers":[{"hue":"#e9ebed"},{"saturation":10},{"lightness":69},{"visibility":"on"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"simplified"},{"saturation":"-30"},{"lightness":"50"}]}];
# mapStyleNiceLandscape = [{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry","stylers":[{"visibility":"on"},{"color":"#C6E2FF"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"color":"#C5E3BF"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#D1D1B8"}]}];

class RichMarkerBuilder extends Gmaps.Google.Builders.Marker #inherit from builtin builder
  #override create_marker method
  create_marker: ->
    options = _.extend @marker_options(), @rich_marker_options()
    @serviceObject = new RichMarker options #assign marker to @serviceObject

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute 'class', 'marker_container'
    marker.innerHTML = @args.title
    { content: marker }

@buildMap = (markers_arg) ->
  handler = Gmaps.build 'Google', { # builders: { Marker: RichMarkerBuilder} } #dependency injection
    # builders: { Marker: RichMarkerBuilder }, #dependency injection
    markers: { #clusterer: null // turn off clusterization
      clusterer: {
        gridSize: 30, # diameter of cluster marker image
        maxZoom: 10,
        styles: [
          {
            fontFamily: font_family,
            fontWeight: font_weight,
            textSize: 14,
            textColor: text_color,
            width:  30,
            height: 30,
            url: base_url + 'marker_cluster.svg',
          },
          {
            fontWeight: font_weight,
            fontFamily: font_family,
            textSize: 15,
            textColor: text_color,
            width:  35,
            height: 35,
            url: base_url + 'marker_cluster.svg',
          },
          {
            fontWeight: font_weight,
            fontFamily: font_family,
            textSize: 16,
            textColor: text_color,
            height: 40,
            width:  40,
            url: base_url + 'marker_cluster.svg',
          },
        ]
      }
    }
  }
  handler.buildMap { 
    provider: {
      zoom: 4,
      center: new google.maps.LatLng(52.31, 13.22),
      # mapTypeId: google.maps.MapTypeId.TERRAIN,
      styles:    mapStyleMyFork,
      disableDefaultUI:   true,
      mapTypeControl:     false,
      scaleControl:       false,
      streetViewControl:  false,
      zoomControl:        true,
      zoomControlOptions: {
        style: google.maps.ZoomControlStyle.LARGE,
        position: google.maps.ControlPosition.RIGHT_TOP, #LEFT_CENTER,
      },
    }, internal: {id: 'map'} }, ->
    markers = handler.addMarkers(markers_arg)
    # handler.bounds.extendWith(markers)
    # handler.fitMapToBounds()
    $('.map_link').click -> 
      zoom = if handler.getMap().getZoom() == 4 then 0 else 4
      handler.getMap().setZoom(zoom)

# for marker in markers
#   google.maps.event.addListener marker, 'mouseover', ->
#     @infowindow.open handler.getMap() marker 
#       # handler.getMap().setZoom(0)
#     # infowindow.open handler.getMap(), marker
#     console.log(handler.getMap().getBounds().getNorthEast().toString())
# google.maps.event.addListener handler.getMap(), 'mouseout', ->
#      console.log(handler.getMap().getBounds().getNorthEast().toString())
# google.maps.event.addListener marker, 'mouseover', ->
# infowindow.open(handler.getMap(), this)
# handler.event.addListener(marker, 'mouseout', function() {
#   infowindow.close();
# })
