class CreateTouristicVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :touristic_visits do |t|
      t.references :visited_city, null: false, foreign_key: true
      t.datetime :travel_date
      t.string :rating
      t.text :review
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
