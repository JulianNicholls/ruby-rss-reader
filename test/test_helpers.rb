require 'minitest/autorun'
require 'minitest/pride'
require_relative '../helpers.rb'

# test Helpers class

describe RssAppHelpers do
  describe 'linkify' do
    it 'should reject bad stuff, but not throw' do
      RssAppHelpers.linkify(nil).must_equal ''
      RssAppHelpers.linkify(3).must_equal ''
    end

    it 'should do nothing if there is no link to ify' do
      RssAppHelpers.linkify('').must_equal ''
      RssAppHelpers.linkify('no link').must_equal 'no link'
    end

    it 'should translate http links' do
      desired = '<a href="http://link.com" target="_blank">http://link.com</a>'
      RssAppHelpers.linkify('http://link.com').must_equal desired

      desired = '<a href="http://link.com/ndex.html" target="_blank">http://link.com/ndex.html</a>'
      RssAppHelpers.linkify('http://link.com/ndex.html').must_equal desired
    end

    it 'should translate https links' do
      desired = '<a href="https://link.com" target="_blank">https://link.com</a>'
      RssAppHelpers.linkify('https://link.com').must_equal desired

      desired = '<a href="https://link.com/ndex.html" target="_blank">https://link.com/ndex.html</a>'
      RssAppHelpers.linkify('https://link.com/ndex.html').must_equal desired
    end
  end

  describe 'process_cdata' do
    it 'should not change a string that has no CDATA' do
      test_str = 'there is not CDATA in this string'
      RssAppHelpers.process_cdata(test_str).must_equal(test_str)
    end

    it 'should strip out the CDATA headers from a complete string' do
      test_str = '<![CDATA[contains CDATA]]>'
      desired  = 'contains CDATA'
      RssAppHelpers.process_cdata(test_str).must_equal(desired)
    end

    it 'should strip out embedded CDATA headers from a string' do
      test_str = 'text <![CDATA[embedded CDATA]]> text'
      desired  = 'text embedded CDATA text'
      RssAppHelpers.process_cdata(test_str).must_equal(desired)
    end
  end
end
