class CreateBeta < ActiveRecord::Migration
  def change
    create_table :beta do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :desc
      t.string :how_did_you_know

      t.timestamps null: false
    end
  end
end
