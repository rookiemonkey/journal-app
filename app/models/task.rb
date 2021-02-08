class Task < ApplicationRecord

  belongs_to :category

  validates :name,
            presence: true,
            length: { within: 5..50 }

  validates :description,
            presence: true,
            length: { maximum: 150 }

  validates :deadline,
            presence: true

end
