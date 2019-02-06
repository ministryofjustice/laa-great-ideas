# frozen_string_literal: true

module IdeasHelper
  def enum_to_select(input)
    input.keys.map { |k| [t(k), k] }
  end
end
