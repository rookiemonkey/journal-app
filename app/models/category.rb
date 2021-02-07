class Category < ApplicationRecord

  has_many :tasks, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 20 }

  validates :description,
            presence: true,
            length: { within: 10..100 }

end
