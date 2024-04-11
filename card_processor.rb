# Class for processing card details
# Checks if the card to be processed has not expired and if it is a valid card
# Processes the card if the above conditions are met
class CardProcessor
    def initialize(card_number, ccv, owner_name, expiration_date, zip_code, amount, card_type)
      @card_number = card_number
      @ccv = ccv
      @owner_name = owner_name
      @expiration_date = expiration_date
      @zip_code = zip_code
      @amount = amount
      @card_type = card_type
    end
  
    # Checks if card has expired
    def card_expired?
      month, year = @expiration_date.split('/').map(&:to_i)
  
      return true if Time.now.year > year.to_i
  
      if Time.now.year == year
        Time.now.month <= month
      else
        false
      end
    end
  
    # Checks if card is valid
    def is_valid_card_number?
      return false unless ['American Express', 'Mastercard', 'Visa'].include?(@card_type)
      return false if @card_type == 'American Express' && @card_number.size != 15
      return false if %w[Mastercard Visa].include?(@card_type) && @card_number.size != 16
  
      true
    end
  
    # Tries/Processes the card
    def process!
      true
    end
  end
  