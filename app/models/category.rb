class Category < ApplicationRecord

  has_many :category_tasks
  has_many :tasks, through: :category_tasks

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 20 }

  validates :description,
            presence: true,
            length: { within: 10..100 }

end
