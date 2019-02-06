# frozen_string_literal: true

module ReviewDate
  attr_writer :review_year, :review_month, :review_day

  def review_year
    review_date&.strftime('%Y')
  end

  def review_month
    review_date&.strftime('%m')
  end

  def review_day
    review_date&.strftime('%d')
  end

  def update_review_date
    if @review_year.present? || @review_month.present? || @review_day.present?
      begin
        date_str = "#{@review_year}-#{@review_month}-#{@review_day}"
        self.review_date = Date.parse(date_str)
      rescue ArgumentError
        errors.add(:review_date, 'must be a valid date')
      end
    else
      self.review_date = nil
    end
  end
end
