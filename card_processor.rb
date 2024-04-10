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
  
    def card_expired?
      month, year = @expiration_date.split('/').map(&:to_i)
  
      return true if Time.now.year > year.to_i
  
      if Time.now.year == year
        Time.now.month <= month
      else
        false
      end
    end
  
    def is_valid_card_number?
      return false unless ['American Express', 'Mastercard', 'Visa'].include?(@card_type)
      return false if @card_type == 'American Express' && @card_number.size != 15
      return false if %w[Mastercard Visa].include?(@card_type) && @card_number.size != 16
  
      true
    end
  
    # In this exercise we can assume that if everything is otherwise valid the
    # payment will process successfully
    def process!
      true
    end
  end
  