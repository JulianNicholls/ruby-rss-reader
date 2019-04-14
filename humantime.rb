# frozen_string_literal: true

require 'time'

# Class that returns a Human representation of the time elapsed since
# a passed time, or between two times.
class HumanTime
  HOUR_SECS = 3600
  DAY_SECS  = 24 * HOUR_SECS

  def initialize(stamp, now = nil)
    @stamp    = stamp.is_a?(Time) ? stamp : Time.parse(stamp)
    @now      = now || Time.now
    @midnight = Time.new(@now.year, @now.mon, @now.day, 0, 0)
  end

  def to_s
    return today if days.negative?
    return 'Yesterday' if days < 1

    longer + ' ago'
  end

  private

  def today
    return last_hour if elapsed < (71 * 60)

    return 'This morning' if @stamp < midday && @now > midday

    format '%.0f hours ago', hours
  end

  def last_hour
    return 'Just now' if elapsed < 90
    return 'A few minutes ago' if elapsed < 210
    return 'Half an hour ago' if elapsed.between?(28.5 * 60, 31.5 * 60)
    return 'An hour ago' if elapsed.between?(58 * 60 + 30, 65 * 60 - 15)

    format('%.0f minutes ago', (elapsed / 60.0) + 0.45)
  end

  def longer
    return 'A week' if days.between?(6.0, 8.0)
    return 'A fortnight' if days.between?(13.0, 15.0)

    days_weeks
  end

  def days_weeks
    return format('%.0f days', [days, 2].max) if days <= 28
    return format('%.0f weeks', ((days + 3) / 7)) if days <= 49

    months_years
  end

  def months_years
    return format('%.0f months', (days / 30.0)) if days < (20 * 30)

    format '%.0f years', ((days / 365.0) + 0.5)
  end

  def elapsed
    @now - @stamp
  end

  def midday
    @midnight + DAY_SECS / 2
  end

  def hours
    (elapsed / HOUR_SECS) + 0.45
  end

  def days
    (@midnight - @stamp) / DAY_SECS
  end
end
