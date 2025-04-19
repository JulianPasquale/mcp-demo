# frozen_string_literal: true

class VisitedCountryResource < ApplicationResource
  uri 'visited_countries'
  resource_name 'Visited Countries'
  description 'A list of all the visited countries by the user.'
  mime_type 'application/json'

  def content
    Current.user.visited_countries.to_json
  end
end
