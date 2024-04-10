require "csv"

class CardProcessor
  def initialize(card_number, ccv, owner_name, expiration_date, zip_code, amount)
    @card_number = card_number
    @ccv = ccv
    @owner_name = owner_name
    @expiration_date =  expiration_date
    @zip_code = zip_code
    @amount = amount
  end

  def card_expired?
    month,year = @expiration_date.split("/").map(&:to_i)

    return true if Time.now.year > year.to_i
    if Time.now.year == year
      Time.now.month <= month
    else
      false
    end
  end

  # In this exercise we can assume that if everything is otherwise valid the
  # payment will process successfully
  def process!
    true
  end
end

class PaymentProcessor
  def self.process(input)
    @input = input

    @processed_cards = []

    cards_to_try.each do |card|
      processor = CardProcessor.new(
        card[1], card[2], card[0], card[4], card[3], card[5]
      )
      next if processor.card_expired?
      @processed_cards << processor.process!
    end

    report
  end

  def self.report
    "Total payments: #{total_payments}"
  end

  def self.cards_to_try
    @input[1..-1]
  end

  def self.total_payments
    @processed_cards.count { |status| status == true }
  end
end

file_path = File.expand_path("./payments.csv", File.dirname(__FILE__))
puts "Total payments: #{PaymentProcessor.process CSV.read(file_path)}"
