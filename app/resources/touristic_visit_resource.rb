# frozen_string_literal: true

class TouristicVisitResource < ApplicationResource
  uri 'touristic_visits'
  resource_name 'Touristic Visits'
  description 'A list of all the touristic visits made by the user.'
  mime_type 'application/json'

  def content
    Current.user.touristic_visits.to_json
  end
end
