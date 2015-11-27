require 'time'    # For Time.parse

# Class that returns a Human representation of the time elapsed since
# a passed time, or between two times

class HumanTime
  def initialize( stamp, now = 0 )
    @stamp    = stamp.is_a?( Time ) ? stamp : Time.parse( stamp )
    @now      = now == 0 ? Time.now : now
    @midnight = Time.new( @now.year, @now.mon, @now.day, 0, 0 )
    @midday   = Time.new( @now.year, @now.mon, @now.day, 12, 0 )

    @elapsed  = @now - @stamp
    @hours    = (@elapsed / 3600.0) + 0.45
    @days     = (@midnight - @stamp) / 86400.0
  end

  def to_s
    text = longer + ' ago'

    text = 'Yesterday' if @days < 1
    text = today       if @days < 0

    text = 'An hour ago' if @elapsed.between?( 58 * 60 + 30, 65 * 60 - 15 )

    text = 'A couple of minutes ago' if @elapsed < 150

    text = 'Just now' if @elapsed < 90

    text
  end

  def today
    if @elapsed < (71 * 60)
      sprintf '%.0f Minutes ago', (@elapsed / 60.0)
    elsif @stamp < @midday && @now > @midday
      'This morning'
    else
      sprintf '%.0f Hours ago', @hours
    end
  end

  def longer
    if @days <= 28
      sprintf '%.0f Days', [@days, 2].max
    elsif @days <= 49
      sprintf '%.0f Weeks', ((@days + 3) / 7)
    elsif @days < (20 * 30)
      sprintf '%.0f Months', (@days / 30.0)
    else
      sprintf '%.0f Years', ((@days / 365) + 0.5)
    end
  end
end
