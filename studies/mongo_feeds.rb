require 'pp'
require './feedlist'

feedlist = FeedList.new

feedlist.urls.each do |url|
  puts url
end

feedlist.each do |site|
  printf "%-35s  %-70s  Aggregate: %s\n", site[:name], site[:url], site[:aggregate] == 1 ? 'YES' : 'No'
end
