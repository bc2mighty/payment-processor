require "csv"
require './card_processor'
require './report'

# Class for reading card details from an inputs.csv file
# Processes each card details
# Returns a report of the processed payments
class PaymentProcessor
  def self.process(input)
    @input = input
    validate_inputs
    @processed_payments = []

    # Tries each cards with the CardProcessor class
    cards_to_try.each do |card|
      processor = CardProcessor.new(
        card[1], card[2], card[0], card[4], card[3], card[5], card[6]
      )

      # Skips the card processing if card has expired or it's an invalid card
      next if processor.card_expired? || !processor.is_valid_card_number?

      processed = processor.process!
      @processed_payments << card if processed
    end

    # creates new report and print the processed payment details
    report = Report.new(get_processed_payments)
    report.print
  rescue StandardError, ArgumentError => e
    e.message
  end

  # Skips the header in the @input variable
  def self.cards_to_try
    @input[1..-1]
  end
  
  #  Returns the payments processed by the CardProcessor instance
  def self.get_processed_payments
    @processed_payments
  end

  # Throws ArgumentError exception if invalid inputs are fetched from the csv file 
  def self.validate_inputs
    valid_input_count = @input.select {|input| input.is_a?(Array) && input.size == 7}.count
    throw ArgumentError.new "Invalid Payment Inputs Provided" if valid_input_count < 1
  end
end

file_path = File.expand_path("./inputs.csv", File.dirname(__FILE__))
if File.exists?(file_path)
  puts "Report: #{PaymentProcessor.process CSV.read(file_path)}"
end
