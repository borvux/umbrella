require "http"
require "json"
#require 'ascii_charts'

gmaps_api_key = ENV.fetch("GMAPS_KEY")
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

puts "========================================"
puts "    Will you need an umbrella today?    "
puts "========================================"
puts
puts "Where are you?"
location = gets.chomp.gsub(" ", "%20")
#location = "Chicago"

google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + location + "&key=" + gmaps_api_key

# getting to the latitude and longtitude
raw_google_maps_data = HTTP.get(google_maps_url)
parsed_google_maps_data = JSON.parse(raw_google_maps_data)
results_array = parsed_google_maps_data.fetch("results")
first_result_hash = results_array.at(0)
geometry_hash = first_result_hash.fetch("geometry")
location_hash = geometry_hash.fetch("location")

# getting the location
latitude = location_hash.fetch("lat")
longitude = location_hash.fetch("lng")

puts "Checking the weather at #{location}...."
puts "Your coordinates are #{latitude}, #{longitude}."

pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/" + latitude.to_s + "," + longitude.to_s

raw_pirate_weather_data = HTTP.get(pirate_weather_url)
parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data)
currently_hash = parsed_pirate_weather_data.fetch("currently")
temperature = currently_hash.fetch("temperature")

puts "It is currently #{temperature}F."

minutely_hash = parsed_pirate_weather_data.fetch("minutely", false)
next_hour_summary = minutely_hash.fetch("summary")

puts "Next hour: #{next_hour_summary}"
