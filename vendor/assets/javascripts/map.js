function buildMap(markers) {
    $(function() {
        markers = transformMarkers(markers);
        var
            // https://snazzymaps.com/style/5263/lighter-monochrome-fork
            mapStyleMyFork = [{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"lightness":"76"}]},{"featureType":"administrative.country","elementType":"labels.text","stylers":[{"lightness":"30"}]},{"featureType":"landscape.natural","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#ffffff"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"hue":"#1900ff"},{"color":"#c0e8e8"}]},{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"visibility":"on"},{"lightness":700}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#e0ebfa"}]}],
            map = $('#map').gmap3({
                map: {
                    options: {
                        center: new google.maps.LatLng(56.9475, 24.106944), // riga
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
                var markerSide = 25;
                return {
                    latLng: [marker.lat, marker.lng],
                    data: {
                        title: marker.title,
                        infowindow: marker.infowindow
                    },
                    options: {
                        icon: new google.maps.MarkerImage('images/map/marker_one.svg',
                              new google.maps.Size(markerSide, markerSide), // icon size
                              new google.maps.Point(0, 0), // origin
                              new google.maps.Point(markerSide / 2, markerSide / 2)  // anchor
                        )
                    }
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
