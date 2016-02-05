require 'open-uri'
require 'nokogiri'

class WelcomeController < ApplicationController

# todo:
  # countries stat by COUNT OF GROUP BY country 
  # foursquare api
  # check tripster w/o a file

  # has_many
  # http://web.archive.org/web/20100210204319/http://blog.hasmanythrough.com/2008/2/27/count-length-size

  def index
    @countries_count = City.group(:country_alpha2).count.count
    @cities_count    = City.count
    @ru_cities_count = City.where(country_alpha2: 'RU').count
    @us_cities_count = City.where(country_alpha2: 'US').count

    @map_json = markers_json
  end

  def sync # PATCH?
    load_and_parse_tripster
 
    redirect_to action: "index"
  end

  private

    Tripster_url           = 'http://tripster.ru/api/users/m4rr/basic/'
    Cities_json_filename   = 'public/cities.json'
    Tripster_xml_filename  = 'public/m4rr-tripster-data-basic.xml'
    ISO_3166_json_filename = 'public/iso-3166-countries-list.json'

    # https://www.refactor.io/q/7ed1271f18

    def markers_json
      cities = []

      City.all.each do |city|
        cities << { lat: city.latitude, lng: city.longitude, title: city.name_en }
      end

      cities.to_json
    end

    def load_and_parse_tripster
      if doc = load_content_from_internet
        City.delete_all

        doc.xpath("//data/cities/city").each do |e|
          alpha2  = e.xpath("@country_id").to_s
          City.new(
            name_en: e.xpath("@title_en").to_s,
            name_ru: e.xpath("@title_ru").to_s,
            latitude:  e.xpath("@lat").to_s.to_f,
            longitude: e.xpath("@lon").to_s.to_f,
            country_alpha2:  alpha2,
            country_name_en: country_name_by(alpha2)
          ).save
        end
      end
    end

    # def load_content_from_local_file
    #   Nokogiri::XML(File.read(Tripster_xml_filename))
    # end

    def load_content_from_internet
      if doc = open(Tripster_url + '?' + rand(1000).to_s)
        Nokogiri::HTML(doc)
      end
    end

    def country_name_by(abbr)
      @countries_list = JSON.parse(File.read(ISO_3166_json_filename)) if @countries_list.nil?
      @countries_list.select { |e| e['alpha-2'] == abbr }.first['name']
    end

end
