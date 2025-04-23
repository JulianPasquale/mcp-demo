# frozen_string_literal: true

class RecordVisitTool < ApplicationTool
  description 'Record a visit to a city'

  arguments do
    required(:visited_country_code).filled(:string).description('Code of the visited country')
    required(:visited_country_name).filled(:string).description('Name of the visited country')
    required(:visited_city_name).filled(:string).description('Name of the visited city')
    required(:travel_date).filled(:date).description('Date of the visit')
    required(:rating).filled(:integer).description('Rating of the visit')
    required(:review).filled(:string).description('Review of the visit')
  end

  def call(visited_country_code:, visited_country_name:, visited_city_name:, travel_date:, rating:, review:)
    # Get the current user (logged in user)
    user = Current.user

    visited_country = VisitedCountry.find_or_create_by!(
      country_code: visited_country_code, name: visited_country_name, user_id: user.id
      )
    visited_city = VisitedCity.find_or_create_by!(name: visited_city_name, visited_country_id: visited_country.id)

    touristic_visit = TouristicVisit.create(
      user: user,
      visited_city: visited_city,
      travel_date: travel_date,
      rating: rating,
      review: review
    )

    "Visit to #{visited_city_name}, #{visited_country_code} on #{travel_date} recorded!"
  end
end
