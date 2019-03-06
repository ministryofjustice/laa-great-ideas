# frozen_string_literal: true

class AreaOfInterestValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if attribute == :it_system
      validate_it_system(record, attribute) unless value.nil?
    elsif attribute == :business_area
      validate_business_area(record, attribute) unless value.nil?
    end
  end

  private

  def validate_it_system(record, attribute)
    record.errors[attribute] << (options[:message] || 'invalid area of interest') if record.area_of_interest != 'it_development'
  end

  def validate_business_area(rec, attr)
    business_areas_arr = %w[my_business_area other_business_area]
    rec.errors[attr] << (options[:message] || 'invalid area of interest') unless business_areas_arr.include? rec.area_of_interest
  end
end
