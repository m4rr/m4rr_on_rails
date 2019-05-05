class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name_en
      t.string :name_ru
      t.float :latitude
      t.float :longitude
      t.string :country_alpha2
      t.string :country_name_en
      t.string :country_name_ru

      t.timestamps null: false
    end
  end
end
