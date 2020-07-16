# ruby-rank-checker

A command line interface to check a website ranking for a keyword. Rank checkers either cost money or are far more heavyweight than I need. I just want to know where my site ranks for a few keywords. This checker uses headless chrome to search the top ten results of google for a given keyword.

# start your chrome/selenium environment

Start a docker container from the project directory.
```
chmod +x docker.sh
./docker.sh
```

Confirm the container is running.
```
docker ps
```

# run the ruby script

Install gems
```
bundle install
```

Release the bot!
```
ruby script.rb mywebsite.com mykeyword
```
