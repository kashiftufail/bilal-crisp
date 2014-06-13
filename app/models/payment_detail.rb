class PaymentDetail < ActiveRecord::Base

  CREDIT_CARD_REGEX = /^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})/i

  belongs_to :user

  CREDIT_CARDS = ["Mastercard", "VISA", "Visa Debit", "Maestro"]

  validates_presence_of :card_type
  validates_presence_of :issue_date
  validates_presence_of :card_holder_name
  validates_presence_of :credit_card_number
  validates_presence_of :expiration_date
  validates_presence_of :security_code

  validates_format_of :credit_card_number,
                      :with => CREDIT_CARD_REGEX,
                      :message => "should be valid."
end
