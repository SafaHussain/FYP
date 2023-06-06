class Deliverable < Activity
  has_many :submissions, dependent: :delete_all
   has_one :key
end
