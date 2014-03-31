require 'rubygems'
require 'oauth'
require 'json'

# Parse a response from the API and return a user object.
def parse_user_response(response)
  user = nil

  # Check for a successful request
  if response.code == '200'
    # Parse the response body, which is in JSON format.
    # ADD CODE TO PARSE THE RESPONSE BODY HERE
    user = JSON.parse(response.body)

    # Pretty-print the user object to see what data is available.
    puts "Hello, #{user["screen_name"]}!"
  else
    # There was an error issuing the request.
    puts "Expected a response of 200 but got #{response.code} instead"
  end

  user
end

# All requests will be sent to this server.
baseurl = "https://api.twitter.com"

# Verify credentials returns the current user in the body of the response.
address = URI("#{baseurl}/1.1/account/verify_credentials.json")

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# The consumer key identifies the application making the request.
# The access token identifies the user making the request.
consumer_key = OAuth::Consumer.new(
    "kvNa8sL8qrAqgca9KyPJDA",
    "X8MS4fu3TKexKrODZAVpIjC8FoYoywWeTRYm7O7w9s")
access_token = OAuth::Token.new(
    "1566452358-70ZI7sYzK62C7tQfE2GuDYl8qw2sQe2bAGymZlq",
  "0F4g1QyN0XNn1KgwGipqjwr3R8G3yrI9wWOLqXaXqo")

# Issue the request.
request = Net::HTTP::Get.new address.request_uri
request.oauth! http, consumer_key, access_token
http.start
response = http.request(request)
user = parse_user_response(response)
