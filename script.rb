require_relative "google.rb"

target = ARGV[0]
keyword = ARGV[1]
max_page = 10

def log(msg)
  STDOUT.write "\r#{msg}".ljust(100)
end

log("Setting up...")
g = Google.new(keyword, target)
found = {
  page: nil,
  site: nil,
}

(1..max_page).each do |page|
  next unless found[:site].nil?

  log "Sleeping so as not to over-query google..."
  sleep rand(5)
  log "Searching page #{page}..."
  g.go_to_page(page)
  unless g.matched.nil?
    found = {
      page: page,
      site: g.matched,
    }
  end
end

if found[:site].nil?
  log "Could not find #{target} in top #{max_page} pages of google for #{keyword}."
else
  log "Found #{found[:site]} on page #{found[:page]} of google for #{keyword}!"
end