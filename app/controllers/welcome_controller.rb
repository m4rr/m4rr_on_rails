require 'open-uri'
require 'nokogiri'

class WelcomeController < ApplicationController

  http_basic_authenticate_with name: 'm4rr', password: 'ware', except: [:index]

  # todo:
  # countries stat by COUNT OF GROUP BY country

  # has_many
  # http://web.archive.org/web/20100210204319/http://blog.hasmanythrough.com/2008/2/27/count-length-size

  def index
    @cities_count    = City.count
    @ru_cities_count = City.where( country_alpha2: 'RU').count
    @us_cities_count = City.where( country_alpha2: 'US').count
    @countries_count = City.group(:country_alpha2).count.count

    @map_json = markers_json
  end

  def sync # covered by http auth
    load_and_parse_tripster

    redirect_to action: :index
  end

  private

    Tripster_Data_URL = 'http://tripster.ru/api/users/m4rr/basic/'
    ISO_3166_Filename = 'public/iso-3166-countries-list.json'

    # https://www.refactor.io/q/7ed1271f18

    def markers_json
      cities = []

      City.all.each do |city|
        cities << { lat: city.latitude, lng: city.longitude, title: city.name_en }
      end

      cities.to_json
    end

    def load_and_parse_tripster
      City.delete_all

      from_the_internets.xpath("//data/cities/city").each do |e|
        alpha2  = e.xpath("@country_id").to_s
        City.new(
          name_en: e.xpath("@title_en").to_s,
          name_ru: e.xpath("@title_ru").to_s,
          latitude:  e.xpath("@lat").to_s.to_f,
          longitude: e.xpath("@lon").to_s.to_f,
          country_alpha2: alpha2,
          country_name_en: country_name_by(alpha2)
        ).save
      end
    end

    def from_the_internets
      Nokogiri::HTML(open(Tripster_Data_URL + '?' + rand(1000).to_s))
    end

    def country_name_by(abbr)
      @countries_list = JSON.parse(File.read(ISO_3166_Filename)) if @countries_list.nil?
      @countries_list.select { |e| e['alpha-2'] == abbr }.first['name']
    end

end
