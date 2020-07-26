class Gift < ApplicationRecord
  belongs_to :order

  validates :from, presence: true
end
