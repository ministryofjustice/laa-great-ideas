# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if /\A([^@\s]+)@((?:[-a-z0-9]+\.)*justice\.gov\.uk)\z/i.match?(value)

    record.errors[attribute] << (options[:message] || 'must end in justice.gov.uk')
  end
end
