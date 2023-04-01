class Activity < ApplicationRecord
  belongs_to :course
  # attr_accessor :encrypted_file
  # validates :encrypted_file, presence: true
  # has_one :encrypted_file
  self.abstract_class = true
end
