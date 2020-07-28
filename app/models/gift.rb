class Gift < ApplicationRecord
  belongs_to :order, optional: true

  validates :from, presence: true
end
