# frozen_string_literal: true

# Returns a date in this format: 1 January 2019
Date::DATE_FORMATS[:day_month_year] = "%-d %B %Y"
# Returns a time in this format: 1:23am on 1 January 2019
Time::DATE_FORMATS[:time_on_day_month_year] = "%-l:%M%P on %-d %B %Y"
# Returns a date in this format: January 2019
Date::DATE_FORMATS[:month_year] = "%B %Y"
