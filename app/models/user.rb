class User < ApplicationRecord

  require 'rbthemis'
  require "base64"

  validates :username, uniqueness: true
  belongs_to :user_registration, optional: true
  has_many :user_registrations, dependent: :delete_all
  has_many :course_registrations, dependent: :delete_all
  has_many :courses, -> { where(course_registrations: { status: "approved" }) }, through: :course_registrations

  has_secure_password

  after_create :generate_key_pair

  def full_name
    first_name + ' ' + last_name
  rescue NoMethodError
    username
  end

 
  def generate_key_pair
    generator = Themis::SKeyPairGen.new
    private_key, public_key = generator.rsa
    
    if public_key.present?
     public_key=  public_key.force_encoding("BINARY")
     public_key = Base64.strict_encode64(public_key)
     self.public_key= public_key
    else
      flash[:notice]="Public Key in null."
    end
   
    private_key=  private_key.force_encoding("BINARY")
    private_key = Base64.strict_encode64(private_key)

    private_key_path = Rails.root.join('private_key', "#{id}")
    File.write(private_key_path, private_key)
  
    self.save!
    return self
  end


end
