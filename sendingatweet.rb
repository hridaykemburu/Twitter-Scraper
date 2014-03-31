require 'rubygems'
require 'oauth'
require 'json'

# Type of request has changed to POST.
# The request parameters have also moved to the body
# of the request instead of being put in the URL.
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/update.json"
address = URI("#{baseurl}#{path}")
request = Net::HTTP::Post.new address.request_uri
request.set_form_data("status" => "still working")


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
tweet = nil
if response.code == '200' then
  tweet = JSON.parse(response.body)
  puts "Successfully sent #{tweet["text"]}"
else
  puts "Could not send the Tweet! " +
  "Code:#{response.code} Body:#{response.body}"
end
