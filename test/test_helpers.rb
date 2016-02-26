require 'minitest/autorun'
require 'minitest/pride'
require_relative '../helpers.rb'

# test Helpers class

describe RssAppHelpers do
  it 'should reject bad stuff, but not throw' do
    RssAppHelpers.linkify(nil).must_equal ''
    RssAppHelpers.linkify(3).must_equal ''
  end

  it 'should do nothing if there is no link to ify' do
    RssAppHelpers.linkify('').must_equal ''
    RssAppHelpers.linkify('no link').must_equal 'no link'
  end

  it 'should translate http links' do
    RssAppHelpers.linkify('http://link.com')
                 .must_equal '<a href="http://link.com" target="_blank">http://link.com</a>'

    RssAppHelpers.linkify('http://link.com/ndex.html')
                 .must_equal '<a href="http://link.com/ndex.html" target="_blank">http://link.com/ndex.html</a>'
  end

  it 'should translate https links' do
    RssAppHelpers.linkify('https://link.com')
                 .must_equal '<a href="https://link.com" target="_blank">https://link.com</a>'

    RssAppHelpers.linkify('https://link.com/ndex.html')
                 .must_equal '<a href="https://link.com/ndex.html" target="_blank">https://link.com/ndex.html</a>'
  end
end
