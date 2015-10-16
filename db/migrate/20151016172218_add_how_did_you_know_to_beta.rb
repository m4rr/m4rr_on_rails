class AddHowDidYouKnowToBeta < ActiveRecord::Migration
  def change
    add_column :beta, :how_did_you_know, :string
  end
end
