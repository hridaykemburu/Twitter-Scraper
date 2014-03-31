require 'rubygems'
require 'oauth'
require 'json'

print "What would you like to search for? "
searchterms = gets.chomp
print "How many tweets would you like to search for? "
limit = gets.chomp

# Fetch /1.1/statuses/user_timeline.json,
# returns a list of public Tweets from the specified
# account.
baseurl = "https://api.twitter.com"
path    = "/1.1/search/tweets.json"
query   = URI.encode_www_form(
  "q" => searchterms,
  "count" => limit
)
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new address.request_uri

# Print data about a list of Tweets
def print_tweets(tweets, searchterms, limit)
  
    loopmax = limit.to_i
    numOfTweets = 0
    tweets.each do |tweet|
        while numOfTweets < loopmax do 
          puts "Tweet Info"
          puts "Tweet Id: " + tweet[1][numOfTweets]['id'].to_s
          puts "Search Terms: " + searchterms
          puts "User ID: " + tweet[1][numOfTweets]['user']['id'].to_s
          puts "Tweet Text: " + tweet[1][numOfTweets]['text']
          puts "Tweet Date: " + tweet[1][numOfTweets]['created_at']
          if tweet[1][numOfTweets]['entities']['hashtags'].to_a.empty?
           puts "Hashtags: None"
          else
            hashtag_holder = tweet[1][numOfTweets]['entities']['hashtags']
            x = 0
            while hashtag_holder[x]
              puts "#" + hashtag_holder[x].values[0]
              x += 1
            end  
          end
          if tweet[1][numOfTweets].has_key?('retweeted_status') 
            puts "Is Original: No"
          else
            puts "Is Original: Yes"
          end
          puts "Retweet Count: " + tweet[1][numOfTweets]['retweet_count'].to_s
          puts "Favorite Count: " + tweet[1][numOfTweets]['favorite_count'].to_s
          if tweet[1][numOfTweets].has_key?('retweeted_status') 
            puts "Original Status ID: " + tweet[1][numOfTweets]['retweeted_status']['id'].to_s
          else
            puts "Original Tweet"
          end

          puts "User Info"
          puts "Twitter User ID: " + tweet[1][numOfTweets]['user']['id'].to_s
          puts "Twitter Handle: " + tweet[1][numOfTweets]['user']['screen_name']
          puts "Twitter Name: " + tweet[1][numOfTweets]['user']['name']
          puts "Follower Count: " + tweet[1][numOfTweets]['user']['followers_count'].to_s
          puts "Friend Count: " + tweet[1][numOfTweets]['user']['friends_count'].to_s
          
          numOfTweets += 1
          puts "______________"  
      end
    end
end

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Twitter API consumer key and access token
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
  print_tweets(tweets, searchterms, limit)
end
nil
