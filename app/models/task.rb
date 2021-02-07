class Task < ApplicationRecord

  belongs_to :category

  validates :name,
            presence: true,
            length: { within: 5..50 }

end
