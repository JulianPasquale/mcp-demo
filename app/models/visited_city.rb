class VisitedCity < ApplicationRecord
  belongs_to :visited_country
  has_many :touristic_visits, dependent: :destroy

  validates :name, presence: true
end
