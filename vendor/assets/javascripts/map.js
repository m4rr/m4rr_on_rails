function buildMap(markers) {
    $(function() {
        markers = transformMarkers(markers);
        var
            // https://snazzymaps.com/style/5263/lighter-monochrome-fork
            mapStyleMyFork = [{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"lightness":"70"},{"gamma":"1"}]},{"featureType":"administrative.province","elementType":"all","stylers":[{"visibility":"on"},{"lightness":"69"},{"gamma":"1"}]},{"featureType":"administrative.locality","elementType":"all","stylers":[{"hue":"#0049ff"},{"saturation":7},{"lightness":19},{"visibility":"on"}]},{"featureType":"landscape","elementType":"all","stylers":[{"visibility":"simplified"},{"weight":"1"},{"hue":"#70ff00"},{"lightness":"30"},{"gamma":"1.00"}]},{"featureType":"poi","elementType":"all","stylers":[{"hue":"#ff0000"},{"saturation":-100},{"lightness":100},{"visibility":"off"}]},{"featureType":"road","elementType":"geometry","stylers":[{"hue":"#008eff"},{"saturation":-93},{"lightness":31},{"visibility":"off"}]},{"featureType":"road","elementType":"labels","stylers":[{"hue":"#bbc0c4"},{"saturation":-93},{"lightness":31},{"visibility":"on"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"on"},{"lightness":"53"}]},{"featureType":"road.arterial","elementType":"all","stylers":[{"visibility":"on"}]},{"featureType":"road.arterial","elementType":"labels","stylers":[{"hue":"#008eff"},{"saturation":-93},{"lightness":-2},{"visibility":"simplified"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"hue":"#007fff"},{"saturation":-90},{"lightness":-8},{"visibility":"on"}]},{"featureType":"transit","elementType":"all","stylers":[{"hue":"#e9ebed"},{"saturation":10},{"lightness":69},{"visibility":"on"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"simplified"},{"color":"#bde0ff"}]},{"featureType":"water","elementType":"labels.text","stylers":[{"saturation":"-100"},{"color":"#ff0000"},{"lightness":"63"},{"gamma":"1.00"}]}],
            map = $('#map').gmap3({
                map: {
                    options: {
                        center: new google.maps.LatLng(56.9475, 24.106944 - 25), // riga
                        // center: new google.maps.LatLng(52.31, 13.22), // berlin
                        // center: new google.maps.LatLng(43.541050, -40.602783), // atl ocean
                        // center: new google.maps.LatLng(51.51, 0), // london
                        disableDefaultUI: true,
                        mapTypeControl: false,
                        scaleControl: false,
                        streetViewControl: false,
                        styles: mapStyleMyFork,
                        zoom: 4,
                        zoomControl: true,
                        zoomControlOptions: {
                            style: google.maps.ZoomControlStyle.LARGE,
                            position: google.maps.ControlPosition.RIGHT_TOP
                        }
                    }
                },
                marker: {
                    values: markers,
                    events: {
                        mouseover: showTooltip,
                        mouseout: function() {
                            $(this).gmap3({clear: {tag: 'tooltip'}});
                        },
                        click: showTooltip
                    },
                    cluster: {
                        radius: 30,
                        events: {
                            mouseover: function(cluster, e, context) {
                                var titles = $.map(context.data.markers, function(marker) {
                                    return marker.data.title;
                                }).sort();
                                $(this).gmap3(
                                    { clear: {tag: 'tooltip2'} },
                                    {
                                        overlay: {
                                            tag: 'tooltip2',
                                            latLng: context.data.latLng,
                                            options: {
                                                content: '<div class="tooltip" id="tooltip2"><div><span>' + titles.join(', ') + '</span></div></div>',
                                                offset: {
                                                    x: -80,
                                                    y: -25
                                                }
                                            }
                                        }
                                    });
                                setTimeout(function() {
                                    $('#tooltip2').addClass('show');
                                }, 100);
                            },
                            mouseout: function(cluster) {
                                $(this).gmap3({clear: {tag: 'tooltip2'}});
                            },
                            click: function(cluster, event, context) {
                                $(this).gmap3({clear: {tag: 'tooltip2'}});
                                var $map = $(this).gmap3('get');
                                $map.panTo(context.data.latLng);
                                $map.setZoom($map.getZoom() + 2);
                            }
                        },
                        0: {
                            content: "<div class='cluster cluster1'>CLUSTER_COUNT</div>",
                            width: 30,
                            height: 30
                        },
                        5: {
                            content: "<div class='cluster cluster2'>CLUSTER_COUNT</div>",
                            width: 35,
                            height: 35
                        },
                        9: {
                            content: "<div class='cluster cluster3'>CLUSTER_COUNT</div>",
                            width: 40,
                            height: 40
                        }
                    }
                }
            });

        function transformMarkers(markers) {
            return $.map(markers, function(marker, i) {
                var markerSide = 10.0;
                var circlePin = { // marker_one.svg
                    path:  'M-10,0a10,10 0 1,0 20,0a10,10 0 1,0 -20,0\
                            M-2,0a2,2 0 1,0 4,0a2,2 0 1,0 -4,0',
                    strokeColor: '#4990E2',
                    fillColor: '#4990E2',
                    fillOpacity: 0.3,
                    size: new google.maps.Size(markerSide, markerSide),
                    anchor: new google.maps.Point(0, 0),
                    origin: new google.maps.Size(markerSide / 2, markerSide / 2)
                };

                return {
                    latLng: [ marker.lat, marker.lng ],
                    data: {
                        title: marker.title,
                        infowindow: marker.infowindow
                    },
                    options: { icon: circlePin }
                }
            });
        }

        function showTooltip(marker, e, context) {
            $(this).gmap3(
                {clear: {tag: 'tooltip'}},
                {
                    overlay: {
                        tag: 'tooltip',
                        latLng: marker.getPosition(),
                        options: {
                            content: '<div class="tooltip" id="tooltip"><div><span>' + context.data.title + '</span></div></div>',
                            offset: {
                                x: -80,
                                y: -25
                            }
                        }
                    }
                });
            setTimeout(function() {
                $('#tooltip').addClass('show');
            }, 100);
        }

        $('.map_link').click(function() {
            map.setZoom(map.getZoom() === 4 ? 0 : 4);
        });
    });
}
