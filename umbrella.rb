# rubocop:disable Style/StringLiterals
# Write your soltuion here!
require "http"
require "json"
require "dotenv/load"

# prompt to ask the user for location
puts "========================================"
puts "    Will you need an umbrella today?    "
puts "========================================"
puts

print "Where are you: "
location = gets.chomp

puts "Checking the weather at #{location}...."

# google maps api to get the lat and lng
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{ENV.fetch('GMAPS_KEY')}"
raw_gmaps_data = HTTP.get(gmaps_url)
parsed_gmaps_data = JSON.parse(raw_gmaps_data)
result_array = parsed_gmaps_data.fetch("results").at(0)
geometry_hash = result_array.fetch("geometry")
location_hash = geometry_hash.fetch("location")

# getting the lat and lng and showing it
lat = location_hash.fetch("lat")
lng = location_hash.fetch("lng")
puts "Your coordinates are #{lat} #{lng}."

# using pirate weather to get the temp, next hour forcast
pirate_weather_url = "https://api.pirateweather.net/forecast/#{ENV.fetch('PIRATE_WEATHER_KEY')}/#{lat},#{lng}"
raw_pw_data = HTTP.get(pirate_weather_url)
parsed_pw_data = JSON.parse(raw_pw_data)
currently_hash = parsed_pw_data.fetch("currently")

# getting the temp from currently hash
temperature = currently_hash.fetch("temperature")
puts "It is currently #{temperature}°F."

# getting the next hr forcast
minutely_hash = parsed_pw_data.fetch("minutely", false)
summary = minutely_hash.fetch("summary")
puts "Next hour: #{summary}"

# trying to figure out the perception
hourly_hash = parsed_pw_data.fetch("hourly")
hourly_data_array = hourly_hash.fetch("data")
next_twelve_hours = hourly_data_array[1..12]
precip_prob_threshold = 0.10
precipitation = false

# looping through each hour and trying to see if it will rain
next_twelve_hours.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability")

  # if the perception probality is greater than the threshold
  if precip_prob > precip_prob_threshold
    precipitation = true
    precip_time = Time.at(hour_hash.fetch("time"))
    seconds_from_now = precip_time - Time.now
    hours_from_now = seconds_from_now / 60 / 60
    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end

# print if umbrealla is needed or not
if precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
