# Miscellaneous Ruby Scripts

This repo has some Ruby scripts I wrote.

* `markdown_extended.rb`: Does some Markdown translation and handles code sort of differently from the `Redcarpet` default 
* `combine_ad_copy.rb`: Complicated script to perform all permutations of lists of words in different files - the point is to auto-generate keywords to use in online ad buying platforms
* `random_number_generator.rb`: I use this to make passwords.
* `google_client.rb` (in `google_drive`): See below

# `google_client.rb`

I wrote this to do backups of Google Drive documents using the [Ruby Google Client API gem](https://github.com/google/google-api-ruby-client/). As far as I know, there isn't any open source code to do that.

It's still pretty primitive. Here's how it works:

* Use Ruby 2.0. The script uses [Keyword Arguments](http://ruby.about.com/od/beginningruby/ss/Keyword-Arguments.htm), so 1.9 is unsupported.
* **gem install**: `parseconfig`, `google/api_client`, `launchy`
* Make a file called `gd_config.ini` - that's where you should put your Google auth secrets. See below for an example.
* Run `mkdir data` at the command line.
* Add this line in the config file you created in step 1 above.

    target_directory = 'data' # This is why you had to mkdir data above

* Run the script like so, to start backing up from your root folder:

    ruby google_client.rb

* If you want to back up a specific folder (which has to be in your Google Drive root), then do it this way - this will make a backup of all folder whose title contains "Title X" in it:

    ruby google_client.rb 'Title X'

## Caveats

* Images and forms will be ignored.
* The script assumes a specific order in which MIME types are considered, when there are multiple MIME types for a document. This order is dictated by the following line:

    formats=[/office.*sheet/, /officedocument.wordprocessingml/, 'ppt', /text.plain/, /pdf/]

* The script will forget the access token it obtains the first time around, if you don't already have one. You have to remember to write it down into your `gd_config.ini` file
* The script will need to launch a browser to get an authorization code the first time round - so you can't run this on a VPS, or other non-windowed system.

## Sample `gd_config.ini`

    target_directory='data'
    client_id = 12345-l21op8cat789gut52iju.apps.googleusercontent.com
    client_secret = 5DC_A9Secret098ID
    [oauth_creds]
    access_token = ya29.1.the_rest_of_the_cred
    token_type = Bearer
    expires_in = 60
    refresh_token = 1/the-rest_oftheToken
