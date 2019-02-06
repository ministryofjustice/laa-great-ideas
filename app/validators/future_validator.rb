# frozen_string_literal: true

class FutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'cannot be in the past') if !value.blank? && record[attribute] < Date.today
  end
end
