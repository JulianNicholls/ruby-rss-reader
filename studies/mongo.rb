require 'pp'
require 'mongo'

# Explore the chosen MongoDB installation.
class MongoExplorer
  include Mongo
  # Turn off the irritating DEBUG level logging and incidentally redirect it
  # to a file rather than the console.
  Logger.logger       = ::Logger.new('mongo.log')
  Logger.logger.level = ::Logger::INFO

  attr_reader :collections, :dbname

  # Connect to the local installation by default
  def initialize(conn = 'mongodb://mongodb.local/')
    @client = Client.new conn
  end

  def list_databases_with_sizes
    @client.list_databases.each do |db|
      printf "%-20s %2d MB\n", db[:name], db[:sizeOnDisk] / 1_048_576
    end
  end

  # Use by 1-BASED index
  def use_by_index(index)
    use_by_name(db_names[index-1])
  end

  # Use name database
  def use_by_name(db)
    @dbname       = db
    @client       = @client.use db
    @db           = @client.database
    @collections  = @db.collection_names
  end

  def database_menu
    format = db_names.size > 9 ? "%2d" : "%d"

    db_names.each_with_index do |dbname, index|
      printf "#{format}: %s\n", index+1, dbname
    end
  end

  def db_names
    @dbs ||= @client.database_names
  end
end

exp = MongoExplorer.new
selected = ''

exp.list_databases_with_sizes

loop do
  puts "\n\tDatabases\n"

  exp.database_menu

  unless selected.empty?
    puts "\nSelected: #{selected} - Collections: #{exp.collections.join ', '}"
  end
  print "\n(1-#{exp.db_names.size}) Select Database, (Q)uit: "

  option = $stdin.gets.chomp.downcase

  case option
  when 'q'    then exit

  else  # Probably a number
    index = option.to_i

    if index == 0
      puts "Invalid Choice"
    else
      exp.use_by_index(index)
      selected = exp.dbname
    end
  end
end
