class VisitedCountry < ApplicationRecord
  belongs_to :user
  has_many :visited_cities, dependent: :destroy

  validates :name, :country_code, presence: true
end
