require 'mongo'

# List of RSS Feeds loaded from the sites collection of the feeds DB under Mongo
class FeedList
  include Mongo
  include Enumerable

  # Turn off the irritating DEBUG level logging and incidentally redirect it
  # to a file rather than the console.
  Logger.logger       = ::Logger.new('mongo.log')
  Logger.logger.level = ::Logger::INFO

  def initialize
    client = Client.new('mongodb://mongodb.local/feeds')
    @sites = client['sites']
  end

  def each
    @sites.find.each do |site|
      yield site
    end
  end
end

if $PROGRAM_NAME == __FILE__
  list = FeedList.new

  list.sort_by { |item| item[:name] }.each do |feed|
    printf "%-35s  %s\n", feed[:name], feed[:url]
  end
end
