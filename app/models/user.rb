class User < ActiveRecord::Base
  has_many :companies
  has_one :address
  has_one :user_plan
  has_one :request_upgrade
  has_one :company_profile
  has_one :avatar
  has_one :company_avatar
  has_one  :user_info
  has_many :primary_trades
  has_many :secondary_trades
  has_many :email_notifications
  has_many :notifications
  has_many :project_portfolios
  has_many :package_downloads
  has_many :hc_invites
  has_many :rfis
  has_one  :user_subscription
  accepts_nested_attributes_for :companies
  belongs_to :user_tender



  validates :first_name, presence: true
  #validates :company, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :email, :presence => true, :uniqueness => true

  before_save :hash_password,:email_regex



  def self.get_user_info password,email
    if password.present? && email.present?
      user_password = "#{Digest::MD5.hexdigest(password)+Digest::MD5.hexdigest('AdmIn')}"
      user = User.where(:email => email,:password =>user_password).first

      if user.id > 0
        user.id
      else
        nil
      end
    else
      nil
    end
  end

  def self.is_number? str
    true if Float(str) rescue false
  end

  def self.rehash_password password
    "#{Digest::MD5.hexdigest(password)+Digest::MD5.hexdigest('AdmIn')}"
  end

  def self.validate_password password
    if password.size >= 8
      if !check_number_from_string password
        return 'number'
      end
      if !check_capital_from_string password
        return 'letter'
      end

      if !check_special_char_from_string password
        return 'character'
      end
    else
      return 'length'
    end
  end


  def self.check_number_from_string str
    puts str.inspect
    if str =~ /\d/
      true
    else
      false
    end
  end

  def self.company_completeness id
    progress = []
    user = find(id)

    if user.trade_name.present?
      progress <<  5
    else
      progress <<  0
    end
    if user.abn.present?
      progress <<  5
    else
      progress <<  0
    end
    if user.company_profile.present?
      puts "user.company_profile.acn ==========> #{user.company_profile.acn.present?}"
      if user.company_profile.acn.present?
        progress <<  10
      else
        progress <<  0
      end
      if user.company_profile.about_me.present?
        progress <<  15
      else
        progress <<  0
      end
      if user.company_profile.number_of_employees.present?
        progress <<  5
      else
        progress <<  0
      end
      if user.company_profile.commenced_operation.present?
        progress <<  5
      else
        progress <<  0
      end
      if user.company_profile.project_range.present?
        progress <<  5
      else
        progress <<  0
      end
      if user.company_profile.contact_number.present?
        progress <<  5
      else
        progress <<  0
      end
      if user.company_profile.website.present?
        progress <<  5
      else
        progress <<  0
      end
      if user.company_profile.linkedin.present?
        progress <<  2
      else
        progress <<  0
      end
    end
    if user.address.present?
      progress <<  5
    else
      progress <<  0
    end
    if user.primary_trades.present?
      progress <<  5
    else
      progress <<  0
    end
    if user.secondary_trades.present?
      progress <<  10
    else
      progress <<  0
    end

    if user.company_avatar.present?
      if user.role == 'Head Contractor'
        progress <<  28
      else
        progress <<  18
      end


    else
      progress <<  0
    end
    puts "progress ========> #{progress}"
    progress.sum
  end

  def self.check_capital_from_string str
    caps = str.scan(/[A-Z]+/)
    puts "CAPS:#{caps.inspect}"
    if caps.present?
      true
    else
      false
    end
  end

  def self.check_special_char_from_string str
    special = "?<>@'!,?[]}{=-)(*&^%$#`~{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/

    if str =~ regex
      true
    else
      false
    end
  end

  def self.execute_token_expiration user_id
    user = User.find(user_id)
    if user.present?
      if user.unique_key.present?
        User.where(:id => user.id).update_all(:unique_key => nil)
        #user.update_attributes(:unique_key => nil)
      end
    end
  end

  def self.execute_tendercon_key
    "#{Digest::MD5.hexdigest(Time.now.strftime('%Y%m%d%H%M%S').to_s)+Digest::MD5.hexdigest('Tendercon1234')}"
  end

  def self.check_invited_user id

    users = self.where("parent_id = #{id} and position is null")


  end

  def self.hc_role(id)
    user = self.find(id)

    if user.present?
      if user.role == 'Head Contractor'
        true
      else
        false
      end
    else
      false
    end
  end

  def self.sc_role(id)
    user = self.find(id)

    if user.present?
      if user.role == 'Sub Contractor'
        true
      else
        false
      end
    else
      false
    end
  end

  def free_plan?
    if self.user_plan.present?
      if self.user_plan.plan == 'STARTER PLAN $0' || self.user_plan.plan == 0
        true
      else
        false
      end
    else
      false
    end


  end



  protected

  def hash_password
    if self.password.to_s == self.confirmed_password.to_s
      puts "EQUAL"
      self.password = "#{Digest::MD5.hexdigest(self.password)+Digest::MD5.hexdigest('AdmIn')}"
      puts "self.password:#{self.password}"
      self.confirmed_password = self.password
      true
    else
      puts "TEST"
      self.errors.add :password, " and confirmed password does not match. Please try again."
      false
    end
  end

  def email_regex
    if email.present? and not email.match(/\A[^@]+@[^@]+\z/)
      self.errors.add :email, " is not a valid email format"
      false
    else
      true
    end
  end


end