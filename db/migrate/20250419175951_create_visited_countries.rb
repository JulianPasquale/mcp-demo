class CreateVisitedCountries < ActiveRecord::Migration[8.0]
  def change
    create_table :visited_countries do |t|
      t.string :name, null: false
      t.string :country_code, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
