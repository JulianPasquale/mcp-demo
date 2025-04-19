# frozen_string_literal: true

class UserResource < ApplicationResource
  uri 'users'
  resource_name 'Users'
  description 'A list of all the users in the database.'
  mime_type 'application/json'

  def content
    User.all.to_json
  end
end
