# Primary Author: Jonathan Allen

# Checks that record is a valid email format.
# Validator from http://edgeguides.rubyonrails.org/active_record_validations.html
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end