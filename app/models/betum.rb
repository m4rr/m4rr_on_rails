class EmailValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    if record.errors[attribute].count == 0
      unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors[attribute] << (options[:message] || "is invalid")
      end
    end
  end
  
end

class Betum < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, email: true
  validates :desc, presence: true
  validates :how_did_you_know, presence: true

end
