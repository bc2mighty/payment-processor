require 'fileutils'

class Report
  def initialize(payments)
    @payments = payments
    @amount_by_card_type = {}
  end

  def total_payments
    @payments.count
  end

  def total_dollar_amount_processed
    @payments.inject(0.0) { |total, arr| total + cent_to_dollar(arr[5]) }
  end

  def get_amount_by_card_type
    @payments.each do |card|
      amount = cent_to_dollar(card[5])
      if @amount_by_card_type.key?(card[6])
        @amount_by_card_type[card[6]] += amount
      else
        @amount_by_card_type[card[6]] =
          amount
      end
    end
    @amount_by_card_type
  end

  def rename_report_file
    filename = "#{Dir.getwd}/inputs.csv"
    new_filename = "#{Dir.getwd}/#{Time.now.strftime("%Y-%m-%d %H:%M")}.csv"
    FileUtils.mv(filename, new_filename)
  end

  def cent_to_dollar(amount)
    amount.to_f / 100
  end

  def print
    rename_report_file
    {
      total_payments: total_payments,
      total_dollar_amount_processed: total_dollar_amount_processed,
      amount_by_card_type: get_amount_by_card_type
    }
  end
end