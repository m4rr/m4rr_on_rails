function buildMap(markers){
    $(function(){
        markers = transformMarkers(markers);
        var
            // mapStyleMyFork = [{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"lightness":"65"}]},{"featureType":"administrative.locality","elementType":"all","stylers":[{"hue":"#2c2e33"},{"saturation":7},{"lightness":19},{"visibility":"on"}]},{"featureType":"landscape","elementType":"all","stylers":[{"hue":"#ffffff"},{"saturation":-100},{"lightness":100},{"visibility":"simplified"}]},{"featureType":"poi","elementType":"all","stylers":[{"hue":"#ffffff"},{"saturation":-100},{"lightness":100},{"visibility":"off"}]},{"featureType":"road","elementType":"geometry","stylers":[{"hue":"#008eff"},{"saturation":-93},{"lightness":31},{"visibility":"off"}]},{"featureType":"road","elementType":"labels","stylers":[{"hue":"#bbc0c4"},{"saturation":-93},{"lightness":31},{"visibility":"on"}]},{"featureType":"road.arterial","elementType":"labels","stylers":[{"hue":"#bbc0c4"},{"saturation":-93},{"lightness":-2},{"visibility":"simplified"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"hue":"#e9ebed"},{"saturation":-90},{"lightness":-8},{"visibility":"simplified"}]},{"featureType":"transit","elementType":"all","stylers":[{"hue":"#e9ebed"},{"saturation":10},{"lightness":69},{"visibility":"on"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"simplified"},{"saturation":"-30"},{"lightness":"50"}]}],
            mapStyleMyFork = [{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"lightness":"76"}]},{"featureType":"landscape.natural","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#ffffff"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"hue":"#1900ff"},{"color":"#c0e8e8"}]},{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"visibility":"on"},{"lightness":700}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#e0ebfa"}]}],
            map = $('#map').gmap3({
                map: {
                    options: {
                        zoom: 4,
                        center: new google.maps.LatLng(52.31, 13.22), // berlin
                      //center: new google.maps.LatLng(43.541050, -40.602783), // atl ocean
                      //center: new google.maps.LatLng(51.51, 0), // london
                        styles: mapStyleMyFork,
                        disableDefaultUI: true,
                        mapTypeControl: false,
                        scaleControl: false,
                        streetViewControl: false,
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
                        mouseout: function(){
                            $(this).gmap3({clear: {tag: 'tooltip'}});
                        },
                        click: showTooltip
                    },
                    cluster:{
                        radius: 30,
                        events: { 
                            mouseover: function(cluster, e, context){
                                var
                                    titles = $.map(context.data.markers, function(marker){
                                        return marker.data.title;     
                                    }).sort();
                                $(this).gmap3(
                                    {clear: {tag: 'tooltip2'}},
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
                                setTimeout(function(){
                                    $('#tooltip2').addClass('show');    
                                }, 100);
                            },
                            mouseout: function(cluster){
                                $(this).gmap3({clear: {tag: 'tooltip2'}});
                            },
                            click: function(cluster, event, context){
                                $(this).gmap3({clear: {tag: 'tooltip2'}});
                                var
                                    $map = $(this).gmap3('get');
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
                        10: {
                            content: "<div class='cluster cluster3'>CLUSTER_COUNT</div>",
                            width: 40,
                            height: 40
                        }
                    }
                }
            }); 
            
        function transformMarkers(markers)
        {
            return $.map(markers, function(marker, i)
            {
                return {
                    latLng: [marker.lat, marker.lng], 
                    data: {
                        title: marker.title,
                        infowindow: marker.infowindow
                    },
                    options: {
                        icon: new google.maps.MarkerImage('images/map/marker_one.svg',
                            new google.maps.Size(  20, 20), // icon size
                            new google.maps.Point(  0,  0), // origin
                            new google.maps.Point( 10, 10)  // anchor
                        )
                    }
                }   
            });
        }
        
        function showTooltip(marker, e, context){
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
            setTimeout(function(){
                $('#tooltip').addClass('show');    
            }, 100);
            
        }
        
        $('.map_link').click(function(){
            map.setZoom(map.getZoom() === 4 ? 0 : 4);
        });
        
    });
}