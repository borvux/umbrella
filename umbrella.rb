# rubocop:disable Style/StringLiterals
# Write your soltuion here!
require "http"
require "json"
require "dotenv/load"

puts "========================================"
puts "    Will you need an umbrella today?    "
puts "========================================"
puts
print "Where are you: "

location = gets.chomp

puts "Checking the weather at #{location}"
