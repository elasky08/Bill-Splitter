# Primary Author: Jonathan Allen

# Checks that record is a valid currency format. Allows for optional cents, thousands separators, and two-digit fraction.
class CurrencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$/ && 
      # Regex from: http://stackoverflow.com/questions/354044/what-is-the-best-u-s-currency-regex
      record.errors[attribute] << (options[:message] || "is not a currency amount")
    end
  end
end