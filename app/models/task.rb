class Task < ApplicationRecord

  belongs_to :user
  belongs_to :category
  validate :deadline_not_past

  validates :name,
            presence: true,
            length: { maximum: 20 }

  validates :description,
            presence: true,
            length: { maximum: 2500 }

  validates :deadline,
            presence: true

  
  private

  # deadline is an instance of ActiveSupport::TimeWithZone
  # https://api.rubyonrails.org/v6.1.0/classes/ActiveSupport/TimeWithZone.html
  def deadline_not_past
    return if (deadline.nil? or deadline.today?)

    if self.new_record?
      return errors.add(:deadline, "is already past") if deadline.past?
    end

    unless self.new_record?
      old_deadline, new_deadline = self.deadline_change

      return if old_deadline.nil?

      return if ((new_deadline == old_deadline) and !new_deadline.past?)

      return errors.add(:deadline, "is already past") if new_deadline.past?
    end
  end

end
