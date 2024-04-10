require "csv"
require './card_processor'
require './report'

class PaymentProcessor
  def self.process(input)
    @input = input
    @processed_payments = []

    cards_to_try.each do |card|
      processor = CardProcessor.new(
        card[1], card[2], card[0], card[4], card[3], card[5], card[6]
      )
      next if processor.card_expired? || !processor.is_valid_card_number?

      processed = processor.process!
      @processed_payments << card if processed
    end
  end

  def self.cards_to_try
    @input[1..-1]
  end

  def self.get_processed_payments
    @processed_payments
  end
end

file_path = File.expand_path("./payments.csv", File.dirname(__FILE__))
puts "Total payments: #{PaymentProcessor.process CSV.read(file_path)}"
