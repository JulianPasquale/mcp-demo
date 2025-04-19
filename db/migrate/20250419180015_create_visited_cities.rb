class CreateVisitedCities < ActiveRecord::Migration[8.0]
  def change
    create_table :visited_cities do |t|
      t.string :name, null: false
      t.references :visited_country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
