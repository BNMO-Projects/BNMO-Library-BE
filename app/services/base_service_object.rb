# frozen_string_literal: true

class BaseServiceObject
  attr_reader :errors, :result
  def initialize
    @errors = []
    @result = nil
  end

  def call
    raise NotImplementedError, "You must implement the call method in #{self.class}"
  end

  def success?
    errors.empty?
  end

  protected

  def required_params?(params, expected_keys)
    expected_keys.all? { |key| params.key?(key) }
  end

  def pagination_metadata(count, page, limit)
    total = count
    total_page = (total.to_f / limit).ceil

    { total: total, page: page, totalPage: total_page }
  end

  attr_writer :errors, :result
end
