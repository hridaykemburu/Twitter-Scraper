require 'rubygems'
require 'oauth'
require 'json'

# Fetch /1.1/statuses/user_timeline.json,
# returns a list of public Tweets from the specified
# account.
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/user_timeline.json"
query   = URI.encode_www_form(
    "screen_name" => "tridentexample",
    "count" => 5,
)
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new address.request_uri

# Print data about a list of Tweets
def print_timeline(tweets)
    tweets.each do |tweet|
    puts tweet['text']
    end
end

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
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Parse and print the Tweet if the response code was 200
tweets = nil
if response.code == '200' then
  tweets = JSON.parse(response.body)
  print_timeline(tweets)
end
nil
