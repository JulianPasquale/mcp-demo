# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'bcrypt'

# Clear existing data
puts "Clearing existing data..."
TouristicVisit.destroy_all
VisitedCity.destroy_all
VisitedCountry.destroy_all
User.destroy_all

# Create 10 users
puts "Creating users..."
users = []
10.times do |i|
  users << User.create!(
    email_address: "user#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
end

# Countries and their cities
travel_data = {
  "France" => {
    code: "FR",
    cities: ["Paris", "Nice", "Lyon", "Bordeaux", "Marseille"]
  },
  "Italy" => {
    code: "IT",
    cities: ["Rome", "Venice", "Florence", "Milan", "Naples"]
  },
  "Spain" => {
    code: "ES",
    cities: ["Barcelona", "Madrid", "Seville", "Valencia", "Granada"]
  },
  "Germany" => {
    code: "DE",
    cities: ["Berlin", "Munich", "Hamburg", "Frankfurt", "Cologne"]
  },
  "United Kingdom" => {
    code: "GB",
    cities: ["London", "Edinburgh", "Manchester", "Liverpool", "Bath"]
  },
  "Japan" => {
    code: "JP",
    cities: ["Tokyo", "Kyoto", "Osaka", "Hiroshima", "Sapporo"]
  },
  "Thailand" => {
    code: "TH",
    cities: ["Bangkok", "Chiang Mai", "Phuket", "Ayutthaya", "Pattaya"]
  },
  "Australia" => {
    code: "AU",
    cities: ["Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide"]
  },
  "Brazil" => {
    code: "BR",
    cities: ["Rio de Janeiro", "São Paulo", "Salvador", "Brasília", "Manaus"]
  },
  "Canada" => {
    code: "CA",
    cities: ["Toronto", "Vancouver", "Montreal", "Quebec City", "Ottawa"]
  }
}

puts "Creating visits..."
# For each user, create 5-7 country visits with cities and touristic visits
users.each do |user|
  # Randomly select 5-7 countries for this user
  selected_countries = travel_data.keys.sample(rand(5..7))

  selected_countries.each do |country_name|
    country_data = travel_data[country_name]

    # Create visited country
    visited_country = VisitedCountry.create!(
      name: country_name,
      country_code: country_data[:code],
      user: user
    )

    # Create 2-3 visited cities for this country
    selected_cities = country_data[:cities].sample(rand(2..3))
    selected_cities.each do |city_name|
      visited_city = VisitedCity.create!(
        name: city_name,
        visited_country: visited_country
      )

      # Create touristic visit
      TouristicVisit.create!(
        visited_city: visited_city,
        user: user,
        travel_date: rand(2.years.ago..Time.current),
        rating: TouristicVisit.ratings.keys.sample,
        review: [
          "Amazing experience! Would definitely visit again.",
          "Beautiful city with rich culture and history.",
          "Great food and friendly people.",
          "Incredible architecture and museums.",
          "Wonderful atmosphere and lots to see.",
          "A must-visit destination!",
          "Unforgettable experience.",
          "Loved exploring the local attractions.",
          "Perfect vacation spot.",
          "Rich in history and modern amenities."
        ].sample
      )
    end
  end
end

puts "Seed completed successfully!"
puts "Created #{User.count} users"
puts "Created #{VisitedCountry.count} visited countries"
puts "Created #{VisitedCity.count} visited cities"
puts "Created #{TouristicVisit.count} touristic visits"
