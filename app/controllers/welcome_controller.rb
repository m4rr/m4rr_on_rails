require 'open-uri'

class WelcomeController < ApplicationController

# todo:
  # countries stat by COUNT OF GROUP BY country 
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
    cities_refresh(true)
    build_markers_json
    redirect_to action: "index"
  end

  private

    Cities_json_filename   = 'public/cities.json'
    Tripster_xml_filename  = 'public/m4rr-tripster-data-basic.xml'
    ISO_3166_json_filename = 'public/iso-3166-countries-list.json'

    def visited_cities
      @countries_count = City.group(:country_alpha2).count.count
      @cities_count    = City.count
      @ru_cities_count = City.where(country_alpha2: 'RU').count
      @us_cities_count = City.where(country_alpha2: 'US').count

      return File.read(Cities_json_filename) if File.exist? Cities_json_filename
      return build_markers_json
    end

    def build_markers_json
      cities_array = Array.new
      cities = City.all
      cities = cities_refresh if cities.nil? || cities.empty?
      cities.each { |city|
        cities_array << {
          lat: city.latitude,
          lng: city.longitude,
          title: "#{city.name_en}",
          # title_full: "#{city.country_name_en}: #{city.name_en}",
        }
      }
      File.write(Cities_json_filename, cities_array.to_json)
      cities_array.to_json
    end

    def cities_refresh(force=false)
      City.delete_all

      xml_content = force ? load_content_from_internet : load_content_from_local_file
      xml_content.xpath("//data/cities/city").each { |e|
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

    def load_content_from_local_file
      Nokogiri::XML(File.read(Tripster_xml_filename))
    end

    def load_content_from_internet
      Nokogiri::HTML(open('http://tripster.ru/api/users/m4rr/basic/?213'))
    end

    def country_name_by(abbr)
      @countries_list = JSON.parse(File.read(ISO_3166_json_filename)) if @countries_list.nil?
      @countries_list.select { |e| e['alpha-2'] == abbr }.first['name']
    end

end
