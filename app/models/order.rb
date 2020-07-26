class Order < ApplicationRecord
  belongs_to :product
  belongs_to :child

  has_one :gift

  validates :shipping_name, presence: true

  def to_param
    user_facing_id
  end
end
