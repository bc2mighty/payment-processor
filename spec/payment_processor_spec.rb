require "spec_helper"
require_relative "../payment_processor"

describe PaymentProcessor do
  describe ".process" do
    it "returns the number of cards that successfully processed" do
      input = [
        csv_headers,
        row_from_string(valid_card_amex),
        row_from_string(valid_card_mastercard),
        row_from_string(valid_card_visa),
      ]

      subject = PaymentProcessor.process input

      expect(subject).to eq("Total payments: 3")
    end

    it "does nothing if there's only one row (headers)" do
      input = [csv_headers]

      subject = PaymentProcessor.process input

      expect(subject).to eq("Total payments: 0")
    end

    it "does not process expired cards" do
      input = [
        csv_headers,
        expired_card_row,
        valid_card_row,
      ]

      subject = PaymentProcessor.process(input)

      expect(subject).to eq("Total payments: 1")
    end

    pending "rejects cards with greater or fewer than 16 digits in its number" do
      input = [
        csv_headers,
        "Griffin Byers,520082828282821,818,55068,11/2021,11373,Mastercard".split(","), # 15 digits
        "Griffin Byers,52120082828282821,818,55068,11/2021,11373,Mastercard".split(","), # 17 digits
      ]

      subject = PaymentProcessor.process(input)

      expect(subject).to eq("Total payments: 0")
    end

    pending "allows cards to have exactly 15 digits in its number if it is an AmEx card" do
      subject = PaymentProcessor.process([
        csv_headers,
        "Griffin Byers,520082828282821,818,55068,11/2021,11373,AmEx".split(","),
      ])

      expect(subject).to eq("Total payments: 1")

      subject = PaymentProcessor.process([
        csv_headers,
        "Griffin Byers,520082828282821,818,55068,11/2021,11373,Visa".split(","),
      ])

      expect(subject).to eq("Total payments: 0")
    end
  end
end

def csv_headers
  %w(
    Name
    Card\ Number
    CCV
    Zip\ Code
    Expiration\ Date
    Amount\ (in\ cents),
    Card\ Type
  )
end

def expired_card_row
  row_from_string("Violet Snider,5105105105105100,919,76522,09/2019,981883,Visa")
end

def valid_card_row
  row_from_string([
    valid_card_visa,
    valid_card_mastercard,
    valid_card_amex,
  ].sample)
end

def valid_card_visa
  "Adaline George,4242424242424242,015,35007,01/2030,52100,Visa"
end

def valid_card_mastercard
  "Griffin Byers,5200828282828210,818,55068,11/2021,11373,Mastercard"
end

def valid_card_amex
  "Keeleigh Mackie,371449635398431,2215,35173,10/2025,87345,American Express"
end

def row_from_string(string)
  string.split(",")
end
