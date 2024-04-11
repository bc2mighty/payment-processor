require 'fileutils'

# Class that generates reports for the processed payments
# Processes each card details
# Returns a report of the processed payments
class Report
  attr_accessor :payments, :amount_by_card_type
  FILENAME = "#{Dir.getwd}/inputs.csv"

  def initialize(payments)
    @payments = payments
    @amount_by_card_type = {}
  end

  # Prints report of the processed payments
  def print
    rename_report_file
    {
      total_payments: total_payments,
      total_dollar_amount_processed: total_dollar_amount_processed,
      amount_by_card_type: get_amount_by_card_type
    }
  end

  private
  # Returns the total payments processed
  def total_payments
    @payments.count
  end

  # Returns the total dollar amount payments processed
  def total_dollar_amount_processed
    @payments.inject(0.0) { |total, arr| total + cent_to_dollar(arr[5]) }
  end

  # Returns the total dollar amount payments processed per card type
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

  # Renames the input.csv file that was processed
  def rename_report_file
    if File.exists?(FILENAME)
        new_filename = "#{Dir.getwd}/#{Time.now.strftime("%Y-%m-%d %H:%M")}.csv"
        FileUtils.mv(FILENAME, new_filename)
    end
  end

  def cent_to_dollar(amount)
    amount.to_f / 100
  end
end