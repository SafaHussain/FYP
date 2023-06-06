class Key < ApplicationRecord

 belongs_to :resource, optional: true
  validates :resource, absence: true, if: :deliverable_id_present?

  belongs_to :deliverable, optional: true
  validates :deliverable, absence: true, if: :resource_id_present?

  def resource_id_present?
    resource_id.present?
  end

  def deliverable_id_present?
    deliverable_id.present?
  end
#  belongs_to :document
# belongs_to :video
# belongs_to :url
end