require 'fileutils'

class Report
  def initialize(payments)
    @payments = payments
    @amount_by_card_type = {}
  end
end