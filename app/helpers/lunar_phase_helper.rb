# frozen_string_literal: true

module LunarPhaseHelper # :nodoc:
  # The Julian Date for January 6, 2000. A new moon occurred on this day and it's as good of a base as any.
  BASE_NEW_MOON_DATE = 2_451_549.5

  # The length of a lunar cycle, in Julian time.
  JULIAN_LUNAR_CYCLE = 29.530588853

  ##
  # Calculates the Julian Date from the given Gregorian Date and time.
  # Params:
  # +month+:: The month (1-12) of the date on which to calculate the Julian Date.
  # +day+:: The day (1-31) of the date on which to calculate the Julian Date.
  # +year+:: The year (> 0) of the date on which to calculate the Julian Date.
  # +hour+:: Integer whose value is the hour (0-23) of the time on which to calculate the Julian Date.
  # +minute+:: Integer whose value is the minute (0-59) of the time on which to calculate the Julian Date.
  # +second+:: Integer whose value is the second (0-59) of the time on which to calculate the Julian Date.
  # Returns the Julian Date
  ##
  def gregorian_date_and_time_to_julian_date(month, day, year, hour, minute, second)
    julian_date_at_time_on_julian_day(gregorian_date_to_julian_day_number(month, day, year), hour, minute, second)
  end

  ##
  # Calculates the Julian Day Number from the given Gregorian Date
  # Params:
  # +month+:: The month (1-12) of the date on which to calculate the Julian Date.
  # +day+:: The day (1-31) of the date on which to calculate the Julian Date.
  # +year+:: The year (> 0) of the date on which to calculate the Julian Date.
  # Returns the Julian Day Number
  ##
  def gregorian_date_to_julian_day_number(month, day, year)
    # The following variable evaluates to 1 if the supplied month is January or February.
    is_jan_or_feb = (14 - month) / 12

    # Number of years since March 1, -4800, which is just apparently how you do this according to any resources
    # I can find. The Julian Epoch isn't until Jan 1, -4714, but okay. I'm going to refer to March 1, -4800 as the
    # "anchor" from here on out. I mean that's basically what it is.
    years_since_anchor = year + 4800 - is_jan_or_feb

    # Number of months since last March.
    months_since_march = month + (12 * is_jan_or_feb) - 3

    # Number of days since last March 1.
    # According to Wikipedia:
    # "(153m+2)/5 gives the number of days since March 1 and comes from the
    # repetition of days in the month from March in groups of five."
    days_since_march_first = ((153 * months_since_march) + 2) / 5

    leap_days = (years_since_anchor / 4) - (years_since_anchor / 100) + (years_since_anchor / 400)

    # The Julian Day Number
    # The subtraction of 32045 corrects for the number of days between March 1, -4800 and January 1, -4714
    # Ruby automatically returns the result of this statement.
    day + days_since_march_first + (356 * years_since_anchor) + leap_days - 32_045
  end

  ##
  # Calculates the Julian Date from the Julian Day Number and the given time.
  # Params:
  # +julianDay+:: The Julian Day Number on which to calculate the Julian Date.
  # +hour+:: The hour (0-23) of the time on which to calculate the Julian Date.
  # +minute+:: The minute (0-59) of the time on which to calculate the Julian Date.
  # +second+:: The second (0-59) of the time on which to calculate the Julian Date.
  #
  # Returns the Julian Date
  ##
  def julian_date_at_time_on_julian_day(julian_day_number, hour, minute, second)
    # The Julian Date value is the Julian Day Number, plus the fractions of a day accounted for by the
    # given hour, minute, and second; A day has 24, 1440, and 86400, respectively.
    julian_day_number + hour.fdiv(24) + minute.fdiv(1440) + second.fdiv(86_400)
  end

  ##
  # Determines tonight's lunar phase from the difference between the Julian Date of tonight at midnight GMT and the
  # Julian Date at midnight GMT on a day that a New Moon has occurred in the past, BASE_NEW_MOON_DATE
  #
  # Returns the lunar phase. (0-7)
  ##
  def lunar_phase_tonight
    # The Julian Date at midnight GMT tonight. (i.e. Tomorrow)
    julian_date_tonight = gregorian_date_and_time_to_julian_date(Time.now.month, (Time.now.day + 1), Time.now.year, 12,
                                                                 0, 0)

    # Get the lunar phase from said date
    lunar_phase_from_julian_date(julian_date_tonight)
  end

  ##
  # Determines the lunar phase on a particular Julian Date
  # Params:
  # +julian_date+:: The Julian Date to find the lunar phase for.
  #
  # Returns the lunar phase. (0-7)
  ##
  def lunar_phase_from_julian_date(julian_date)
    # The difference between the Julian Date tonight and the base
    julian_difference = julian_date - BASE_NEW_MOON_DATE - 1

    # If the difference is less than zero (meaning it is somehow before January 6, 2000) then just add the length of
    # a lunar cycle, because the negative number is just the amount of Julian time before the next new moon.
    julian_difference += JULIAN_LUNAR_CYCLE if julian_difference.negative?

    # The "phase date", as I call it, is the modulus of the difference between the given date and the base new moon
    # date (adjusted if the given date predates January 6, 2000) by the length of a lunar cycle in Julian time.
    # We use this phase_date to see where we fall in the cycle and determine the moon's phase.
    phase_date = julian_difference % JULIAN_LUNAR_CYCLE

    # There are eight different phases. However, the moon could appear to be new at the beginning or end of the lunar
    # cycle. Therefore, you will notice there are two 0 cases. They are equal in size and, combined, are equal
    # in size to the other phases.
    if phase_date < 1.84566
      0
    elsif phase_date < 5.53699
      1
    elsif phase_date < 9.22831
      2
    elsif phase_date < 12.91963
      3
    elsif phase_date < 16.61096
      4
    elsif phase_date < 20.30228
      5
    elsif phase_date < 23.99361
      6
    elsif phase_date < 27.86493
      7
    else
      8
    end

    # Return the lunar phase.
  end

  ##
  # Gets the name of the given lunar phase from its ID
  # Params:
  # +phase_id+:: The ID (0-7) of the lunar phase
  #
  # Returns the name of the given lunar phase
  ##
  def get_lunar_phase_name_from_id(phase_id)
    case phase_id
    when 0
      'New Moon'
    when 1
      'Waxing Crescent Moon'
    when 2
      'First Quarter Moon'
    when 3
      'Waxing Gibbous Moon'
    when 4
      'Full Moon'
    when 5
      'Waning Gibbous Moon'
    when 6
      'Last Quarter Moon'
    when 7
      'Waning Crescent Moon'
    else
      'New Moon'
    end
  end

  ##
  # Gets the name of the icon for the given lunar phase from its ID
  # Params:
  # +phase_id+:: The ID (0-7) of the lunar phase
  #
  # Returns the name of the icon of the given lunar phase
  ##
  def get_lunar_icon_name_from_id(phase_id)
    case phase_id
    when 0
      'newMoon.svg'
    when 1
      'waxingCrescent.svg'
    when 2
      'firstQuarter.svg'
    when 3
      'waxingGibbous.svg'
    when 4
      'fullMoon.svg'
    when 5
      'waningGibbous.svg'
    when 6
      'lastQuarter.svg'
    when 7
      'waningCrescent.svg'
    else
      'newMoon.svg'
    end
  end

  ##
  # Retrieves a random exclamation.
  ##
  def random_exclamation
    get_random_line_of_file('exclamations.txt')
  end

  ##
  # Retrieves a random quote.
  ##
  def random_quote
    get_random_line_of_file('quotes.txt')
  end

  ##
  # Retrieves a random line from the selected file.
  # Params:
  # +filename+:: The name of the file to get a random line from
  #
  # Returns a random line from the file specified at filename.
  ##
  def get_random_line_of_file(filename)
    current_line = nil
    File.foreach(Rails.root.join('app', 'assets', 'strings', filename)).each_with_index do |line, number|
      current_line = line if rand < 1.0 / (number + 1)
    end
    current_line
  end
end
