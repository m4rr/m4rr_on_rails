class WelcomeController < ApplicationController

# todo:
  # map pins
  # foursquare api
  # likely to bottom
  # check tripster w/o a file

  def index
    @hash = visited_cities
  end

  private
    def visited_cities
      cities = City.all
      if cities.empty?
         cities_refresh
      end
      Gmaps4rails.build_markers(cities) { |city, marker|
        marker.lat city.latitude
        marker.lng city.longitude
        marker.infowindow "#{city.country_name_en}: #{city.name_en}"
        marker.title "#{city.country_name_en}: #{city.name_en}"
        marker.json({ title: city.name_en })
        marker.picture({
          :url    => "images/map/marker_one.svg",
          :width  => 20,
          :height => 20,
          :anchor => [10, 10],
        })
      }
    end

    def cities_refresh
      City.delete_all
      Nokogiri::XML(File.read("public/m4rr-tripster-data-basic.xml"))
      .xpath("//data/cities/city").each { |e|
        id  = e.xpath("@country_id").to_s
        ru  = e.xpath("@title_ru").to_s
        en  = e.xpath("@title_en").to_s
        lat = e.xpath("@lat").to_s.to_f
        lng = e.xpath("@lon").to_s.to_f
        country_name_en = country_name_by(id)
        City.new(
          :name_en    => en, 
          :name_ru    => ru,
          :latitude   => lat, 
          :longitude  => lng, 
          :country_alpha2  => id, 
          :country_name_en => country_name_en
        ).save
      }
    end

    def country_name_by(abbr)
      if @countries_list == nil
         @countries_list = JSON.parse(File.read('public/iso-3166-countries-list.json'))
      end
      @countries_list.select { |e| e['alpha-2'] == abbr }.first['name']
    end

end
