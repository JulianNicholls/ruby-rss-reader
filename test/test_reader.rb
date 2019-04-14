# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../reader.rb'

describe Feed do
  let(:feed) { Feed.new('test/test_feed.xml') }

  it 'should load all info sections' do
    feed.info.keys.count.must_equal(10) # All INFO_PARTS + time_ago
  end

  it 'should load info text items correctly' do
    feed.info[:title].must_equal 'BBC News - Home'
    feed.info[:link].must_equal \
      'http://www.bbc.co.uk/news/#sa-ns_mchannel=rss&amp;ns_source='\
      'PublicRSS20-sa'
    feed.info[:copyright].must_equal 'Copyright: (C) British Broadcasting '\
      'Corporation, see http://news.bbc.co.uk/2/hi/help/rss/4498287.stm for '\
      'terms and conditions of reuse.'
    feed.info[:description].must_equal 'The latest stories from the Home '\
      'section of the BBC News web site.'
    feed.info[:timestamp].must_equal 'Thu, 26 Nov 2015 18:44:21 GMT'
  end

  it 'should load image-related info items correctly' do
    feed.info[:image_url].must_equal 'http://news.bbcimg.co.uk/nol/shared/img'\
      '/bbc_news_120x60.gif'
    feed.info[:image_caption].must_equal 'BBC News - Home'
    feed.info[:image_width].must_equal '120'
    feed.info[:image_height].must_equal '60'
  end

  it 'should load all 10 items' do
    feed.items.size.must_equal 10
  end

  it 'should load a full set of parts from a comnplete item' do
    feed.items[0].keys.size.must_equal(6) # All ITEM_PARTS + time_ago
  end

  it 'should be able to skip parts from an incomnplete item' do
    feed.items[1].keys.size.must_equal(5) # No Image
  end

  it 'should load all the sections in each item' do
    full_item = feed.items[0]

    full_item[:title].must_equal "Corbyn 'cannot support air strikes'"
    full_item[:description].must_equal \
      'Labour leader Jeremy Corbyn writes to his MPs saying he cannot back '\
      'UK air strikes in Syria - prompting a warning of shadow cabinet '\
      'resignations.'
    full_item[:link].must_equal \
      'http://www.bbc.co.uk/news/uk-politics-34939109#sa-ns_mchannel=rss&amp;'\
      'ns_source=PublicRSS20-sa'
    full_item[:timestamp].must_equal 'Thu, 26 Nov 2015 18:41:16 GMT'
    full_item[:image_url].must_equal \
      'http://c.files.bbci.co.uk/BA53/production/_86899674_breaking_'\
      'image_large-3.png'
  end
end
