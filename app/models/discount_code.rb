class DiscountCode < ActiveRecord::Base

  class CodeValueValidator < ActiveModel::EachValidator
    def validate_each(object, attr, val)
      if (object.code_type == "Discount") && val.to_i > 100
        object.errors[attr] << "can't be greater then 100%"
      end
    end
  end

  belongs_to :user


  CODE_TYPE = %w(Loyalty Discount)
  CODE_HASH = [%w(Percentage Discount), ["Money Off", "Loyalty"]]

  scope :loyalty_points, where(:code_type => 'Loyalty')
  scope :discounted_code, where(:code_type => 'Discount')

  validates :discount_code, :presence => true, :uniqueness => true
  validates :code_type, :inclusion => { :in => CODE_TYPE }
  validates :start_date, :end_date, :presence => true
  validates :value, :presence => true, :numericality => true, :code_value => true

  def self.create_discount_code(user)
    DiscountCode.create(:code_type => "Discount", :user_id => user.ref_id, :discount_code => DiscountCode.generate_random_code)
  end

  def self.generate_random_code
    uppercase_letters = ('A'..'Z').to_a
    lowercase_letters = ('a'..'z').to_a
    digits = (0..9).to_a
    (0...8).map{ (uppercase_letters | lowercase_letters | digits)[rand(62)] }.join
  end

  def self.create_loyalty_code(user)
    n = (user.loyalty_points/100) - user.discount_codes.loyalty_points.count
    n.times do
      code = DiscountCode.create(:code_type => "Loyalty", :user_id => user.id, :discount_code => DiscountCode.generate_random_code)
      UserMailer.loyalty_code(user, code).deliver
    end
  end

end
