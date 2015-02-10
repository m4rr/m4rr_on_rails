class WelcomeController < ApplicationController

# todo:
  # foursquare api
  # check tripster w/o a file

  # has_many
  # http://web.archive.org/web/20100210204319/http://blog.hasmanythrough.com/2008/2/27/count-length-size

  def index
    @map_json = visited_cities
  end

  def sync # PATCH?
    # rm cities_json_filename
    # force refresh cities
  end

  private

    @@cities_json_filename   = 'public/cities.json'
    @@tripster_xml_filename  = 'public/m4rr-tripster-data-basic.xml'
    @@iso_3166_json_filename = 'public/iso-3166-countries-list.json'

    def visited_cities
      return File.read(@@cities_json_filename) if File.exist? @@cities_json_filename
      return build_markers_json
    end

    def build_markers_json
      cities_array = Array.new
      # cities = City.all
      cities = cities_refresh if cities.nil? || cities.empty?
      cities.each { |city|
        cities_array << {
          lat: city.latitude,
          lng: city.longitude,
          title: "#{city.name_en}",
          # title_full: "#{city.country_name_en}: #{city.name_en}",
        }
      }
      File.write(@@cities_json_filename, cities_array.to_json)
      cities_array.to_json
    end

    def cities_refresh
      City.delete_all
      Nokogiri::XML(File.read(@@tripster_xml_filename))
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
      City.all
    end

    def country_name_by(abbr)
      @countries_list = JSON.parse(File.read(@@iso_3166_json_filename)) if @countries_list.nil?
      @countries_list.select { |e| e['alpha-2'] == abbr }.first['name']
    end

end
