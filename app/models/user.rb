require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  TITLES = %w(Mr Mrs Ms)

  has_one :payment_detail, :dependent => :destroy
  has_one :pre_authorization
  accepts_nested_attributes_for :payment_detail
  has_many :bookings, :dependent => :destroy
  has_many :roles
  has_many :referrals, :class_name => "User", :foreign_key => 'ref_id'
  has_many :discount_codes
  belongs_to :referrer, :class_name => "User", :foreign_key => 'ref_id'
  has_one :password_code

  validates_presence_of :first_name
  validates_presence_of :surname
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_presence_of     :address_first
  validates_presence_of     :post_code
  validates_length_of       :email,    :within => 6..100, :allow_blank => true
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :allow_blank => true

  validates_presence_of :mobile_number
  validates_presence_of :home_number, :allow_blank => true
  validates_format_of :home_number, :with => Authentication.home_regex,  :message => Authentication.invalid_home_error, :allow_blank => true
  validates_uniqueness_of   :home_number, :allow_blank => true, :message => "already exists"

  validates :title, :inclusion => { :in => TITLES }


  attr_accessible :payment_detail_attributes, :ref_id, :corporate, :user_company_attributes

  after_create :send_email

  ########## CORPORATE FEATURE CHANGES ################

  has_one :user_plan
  has_one :plan, :through => :user_plan

  has_one :user_company
  has_one :company, :through => :user_company
  accepts_nested_attributes_for :user_company 

  # Don't add presence validation cuz normal user won't have company while corporate user will have.
  validates :user_company, :associated => true

  scope :corporate, where(:corporate => true)
  scope :non_corporate, where(:corporate => false)

  class << self

    def create_with_plan(params)
      plan = Plan.where(:category => params[:category], :name => params[:name]).first
      user = User.new(params[:user])
      begin 
        user.corporate = true unless plan.nil?
        user.transaction do
          if user.save && plan.present?
            user.plan = plan
            raise ActiveRecord::Rollback unless user.plan.persisted?
          end
        end
      rescue => e
        logger.error e.message
      ensure 
        return [user, plan]
      end
    end

  end

  def to_param
    "#{id}-#{full_name.parameterize.titlecase.gsub(" ", "-")}"
  end

  ###############################################

  def send_email
    unless self.corporate?
      UserMailer.registration(self, self.password).deliver
    else
      UserMailer.corporate_registration(self, self.password).deliver
    end
  end

  def has_valid_pre?
    # check have setup pre_authorization
    # if yes check is it valid
    pre = self.pre_authorization
    # check we have more five days till his account is valid
    pre && ( (pre.created_at_time + 1.send(pre.interval_unit)) > Time.now + 5.days )
  end


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :city, :address, :title, :home_number, :post_code, :mobile_number, :surname, :first_name, :address_first, :address_last
  attr_accessor :address

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(home_number, password)
    return nil if home_number.blank? || password.blank?
    u = find_by_home_number(home_number) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def address
    address = [self.address_first.to_s,self.address_last.to_s].join(", ")
    return address.gsub(", ","") if self.address_last.blank?
    address
  end

  def address1
    self.address_first unless self.address_first.blank?
  end

  def address2
    self.address_last unless self.address_last.blank?
  end

  def role_names
    self.roles.collect(&:name)
  end

  def admin?
    self.role_names.include?('admin')
  end

  def name
    self.first_name + " " + self.surname unless (self.first_name.blank? && self.surname.blank?)
  end

  def total_cost
    self.bookings.completed.sum(:cost) || 0
  end

  def loyalty_points
    self.total_cost.to_i
  end

  def new_password
    new_pass = DiscountCode.generate_random_code
    self.password = new_pass
    self.password_confirmation = new_pass
    self.save(false)
    pc = PasswordCode.create :code => new_pass, :user_id => self.id
    new_pass
  end

  def self.search(option, value)
    users = User.where(["#{option} = ?",value])
    users = self.find_by_name(value) if option == "name" 
    users
  end

  def self.find_by_name(value)
    value = [value, "%"].join
    User.where(["first_name like ? OR surname like ?", value, value])
  end

  def full_address
    [self.address, self.city, self.post_code].join(", ")
  end

  def map_address
    [self.address, self.city, "UK"].join(", ")
  end

  def full_name
    "#{title}. #{first_name} #{surname}"
  end

  def update_password(password, confirm_password, old_password)
    if User.authenticate(self.home_number, old_password) && password == confirm_password
      self.password = password
      self.password_confirmation = confirm_password
      user_status = self.save(false)
      return user_status
    end
    false
  end

  def reset_password(new_password, confirm_password)
    if new_password == confirm_password
      self.password = new_password
      self.password_confirmation = confirm_password
      user_status = self.save(false)
      return user_status
    end
    false
  end

end
