class Company < ActiveRecord::Base

  has_many :user_companies
  has_many :users, :through => :user_companies

  def self.names_with_ids
    self.scoped.map { |company| [company.name, company.id] }
  end

  def full_address
    [address, city, postal_code].select { |field| field.present? }.join(", ")
  end
end
