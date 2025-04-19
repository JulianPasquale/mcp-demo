# frozen_string_literal: true

class VisitedCityResource < ApplicationResource
  uri 'visited_cities'
  resource_name 'Visited Cities'
  description 'A list of all the visited cities by the user.'
  mime_type 'application/json'

  def content
    Current.user.visited_cities.to_json
  end
end
