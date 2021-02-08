class Task < ApplicationRecord

  belongs_to :category
  validate :deadline_not_past

  validates :name,
            presence: true,
            length: { within: 5..50 }

  validates :description,
            presence: true,
            length: { maximum: 150 }

  validates :deadline,
            presence: true

  
  private

  # deadline is an instance of ActiveSupport::TimeWithZone
  # available methods aside from .past? 
  # https://api.rubyonrails.org/v6.1.0/classes/ActiveSupport/TimeWithZone.html
  def deadline_not_past
    return if deadline.nil?
    errors.add(:deadline, "is past") if deadline.past?
  end

end
