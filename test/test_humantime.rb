require 'minitest/autorun'
require 'minitest/pride'
require_relative '../humantime.rb'

# test HumanTime class

describe HumanTime do
  let(:now) { Time.new(2014, 1, 7, 14, 0) }

  it 'should be right for the last hour' do
    HumanTime.new('2014-01-07 13:59', now).to_s.must_equal 'Just now'

    HumanTime.new('2014-01-07 13:58', now).to_s.must_equal 'A couple of minutes ago'

    HumanTime.new('2014-01-07 13:30', now).to_s.must_equal 'half an hour ago'

    HumanTime.new('2014-01-07 13:00', now).to_s.must_equal 'An hour ago'
    HumanTime.new('2014-01-07 12:56', now).to_s.must_equal 'An hour ago'
  end

  it 'should be right for the last couple of hours' do
    HumanTime.new('2014-01-07 12:55', now).to_s.must_equal '65 Minutes ago'
    HumanTime.new('2014-01-07 12:54', now).to_s.must_equal '66 Minutes ago'

    HumanTime.new('2014-01-07 12:40', now).to_s.must_equal '2 Hours ago'
    HumanTime.new('2014-01-07 12:01', now).to_s.must_equal '2 Hours ago'
    HumanTime.new('2014-01-07 12:00', now).to_s.must_equal '2 Hours ago'
  end

  it 'should be right earlier in the day' do
    HumanTime.new('2014-01-07 11:59', now).to_s.must_equal 'This morning'
    HumanTime.new('2014-01-07 02:00', now).to_s.must_equal 'This morning'
    HumanTime.new('2014-01-07 00:01', now).to_s.must_equal 'This morning'
  end

  it 'should be right for the day before' do
    HumanTime.new('2014-01-07 00:00', now).to_s.must_equal 'Yesterday'
    HumanTime.new('2014-01-06 23:59', now).to_s.must_equal 'Yesterday'
    HumanTime.new('2014-01-06 13:00', now).to_s.must_equal 'Yesterday'
    HumanTime.new('2014-01-06 12:00', now).to_s.must_equal 'Yesterday'
    HumanTime.new('2014-01-06 09:00', now).to_s.must_equal 'Yesterday'
    HumanTime.new('2014-01-06 00:01', now).to_s.must_equal 'Yesterday'
  end

  it 'should be right for the previous two days' do
    HumanTime.new('2014-01-06 00:00', now).to_s.must_equal '2 Days ago'
    HumanTime.new('2014-01-05 23:59', now).to_s.must_equal '2 Days ago'
    HumanTime.new('2014-01-05 15:00', now).to_s.must_equal '2 Days ago'
    HumanTime.new('2014-01-05 14:00', now).to_s.must_equal '2 Days ago'
    HumanTime.new('2014-01-05 12:00', now).to_s.must_equal '2 Days ago'
    HumanTime.new('2014-01-05 06:00', now).to_s.must_equal '2 Days ago'
  end

  it 'should be right for the previous week' do
    HumanTime.new('2014-01-04 06:00', now).to_s.must_equal '3 Days ago'
    HumanTime.new('2014-01-03 06:00', now).to_s.must_equal '4 Days ago'
    HumanTime.new('2014-01-02 06:00', now).to_s.must_equal '5 Days ago'
    HumanTime.new('2014-01-01 06:00', now).to_s.must_equal 'A week ago'
    HumanTime.new('2013-12-31 06:00', now).to_s.must_equal 'A week ago'
  end

  it 'should be right for the previous month' do
    HumanTime.new('2013-12-30 06:00', now).to_s.must_equal 'A week ago'
    HumanTime.new('2013-12-23 06:00', now).to_s.must_equal 'A fortnight ago'
    HumanTime.new('2013-12-16 06:00', now).to_s.must_equal '3 weeks ago'
    HumanTime.new('2013-12-09 06:00', now).to_s.must_equal '5 Weeks ago'
  end

  it 'should be right for months before' do
    HumanTime.new('2013-11-01 06:00', now).to_s.must_equal '2 Months ago'
    HumanTime.new('2013-07-01 06:00', now).to_s.must_equal '6 Months ago'
    HumanTime.new('2013-01-01 06:00', now).to_s.must_equal '12 Months ago'
    HumanTime.new('2012-07-01 06:00', now).to_s.must_equal '18 Months ago'
    HumanTime.new('2012-06-01 06:00', now).to_s.must_equal '19 Months ago'
  end

  it 'should be right for years before' do
    HumanTime.new('2012-05-01 06:00', now).to_s.must_equal '2 Years ago'
    HumanTime.new('2011-05-01 06:00', now).to_s.must_equal '3 Years ago'
  end
end
