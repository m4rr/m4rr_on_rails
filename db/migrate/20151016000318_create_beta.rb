class CreateBeta < ActiveRecord::Migration
  def change
    create_table :beta do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :desc

      t.timestamps null: false
    end
  end
end
