class TouristicVisit < ApplicationRecord
  belongs_to :visited_city
  belongs_to :user

  has_one :visited_country, through: :visited_city

  validates :travel_date, :rating, :review, presence: true

  enum :rating, {
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5
  }
end
