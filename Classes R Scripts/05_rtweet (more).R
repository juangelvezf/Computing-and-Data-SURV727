if (!require("rtweet")) install.packages("rtweet")
library(rtweet)

help(search_tweets)

ffftweets <- search_tweets(
  q = "#fridaysforfuture", # search for tweets with "#fridaysforfuture" 
  n = 100 #  100 Tweets
  ) 

sun.moon <- search_tweets(
  q = "sun OR moon, lang:en", # search for tweets with either sun ("OR") moon
  n = 100 
)

sun.moon$text[1:5]

Data.science <- search_tweets(
  q = "Data science", # search for Tweets with "data" AND "science",
  n = 100 
)

Data.science$text[1:5]

# See ?search_tweets for more info on query parameters
trump.tweets <- search_tweets(
  "trump, filter:news", # pointing to news articles
  n = 100 
)

trump.tweets <- search_tweets(
  q = "trump, filter:retweets",  # no retweets
                            # (Minus filter)
  n = 100 
)

trump.tweets <- search_tweets(
  "trump, -filter:retweets",  # maximum is 18k
  # (Minus filter)
  n = 18000 
)


trump.tweets$text[1:5]

# If we need more content, set retryonratelimit to TRUE
# Will automatically make several calls to twitter API but with a few minutes in between

trump.tweets <- search_tweets(
  "trump",
  n = 20000,
  retryonratelimit = TRUE
)

# can also exclude retweets with R function parameter
trump.tweets <- search_tweets(
  "trump",
  n = 100,
  include_rts = FALSE
)

# Also interesting: lang setting
trump.tweets <- search_tweets(
  "trump, lang:en", # # only tweets in German about Trump
  n = 100,
  include_rts = FALSE
)

trump.tweets$source


# lets have a look at the dataframe
Data.science[1:5,]

# Which variables do we have?
names(Data.science)

# can also use dplyr syntax
Data.science %>% names()


# Quotes and Retweets
# which tweets are Quotes?
Data.science$is_quote
# How many?
sum(Data.science$is_quote) 
table(Data.science$is_quote) 

# Which tweets were quoted and what exactly was quoted (quoted_text!)?
Data.science$quoted_text[Data.science$is_quote==TRUE]
Data.science$text[Data.science$is_quote==TRUE]

# Can also stream tweets


# e.g. for 30 secs

GOP <- stream_tweets(
                      q = "GOP",
                      timeout = 30)
GOP$created_at[1:5]

# Worst case: nothing is tweeted whilst we're streaming
tweetsfff <- stream_tweets("#fridaysforfuture, lang:de", timeout = 10)


# Can stream longer periods. However, R session will have to run whole time

# Can also download user timelines

# Example: Last 100 of nytimes

timelinenytimes <- get_timelines(user = "nytimes", n = 3200)
timelinenytimes$text[1:5]


## If you want to know more about functions etc, check out documentation
# https://rtweet.info/articles/intro.html

### Get favorites of a user
favesnytimes <- get_favorites(user = "nytimes", n = 100)
favesnytimes$text[1:5]


### Connections between users

# Which users are mentioned by other users?
# Result ist a list!


ffftweets$mentions_user_id[1:5]
ffftweets$mentions_screen_name[1:5]

# Responses to whom?
ffftweets$reply_to_user_id[20:39]



# If we want to stream for longer periods
## search for users with specific tweet or keyword


# be creative 
# Search for users with certain keyword. Then select tweets from period you're interested in

fffusers<- search_users("#fridaysforfuture", n = 1000)
fffusers$screen_name[1:5]
fffusers$description[1:5]

# Get timelines of first five users ;(limit3200 tweets!)
fffusersworkaround <- get_timelines(user = fffusers$user_id[1:5], 
                                    n = 500, 
                                    include_rts = FALSE,
                                    retryonratelimit = TRUE)
fffusersworkaround$text[1:5]

# If you stream for longer periods. COntinously write to a json before parsing the json file to R format
stream_tweets(
  q = "trump",
  timeout = 10,
  file_name = "trump.json",    # tweets will be directly saved
  parse = FALSE               # don't parse
)

# Then load json and parse
trump.tweets <- parse_stream("trump.json")


# Can also stream based on location
# Example: Berlin

stream_tweets(
  c(13.0883,52.3383,13.7612,52.6755), 
  timeout = 180,
  file_name = "berlin2.json",
  parse = FALSE
)
berlin2 <- parse_stream("berlin2.json")
berlin2$text[1:5]
names(berlin2)
# How to get coordinates
# This Blogpost 
# https://www.mzes.uni-mannheim.de/socialsciencedatalab/article/collecting-and-analyzing-twitter-using-r/
# and this one
# https://www.r-bloggers.com/geocoding-with-ggmap-and-the-google-api/


