class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise  :database_authenticatable, 
          :registerable,
          :recoverable,
          :validatable

  validates :email,
          presence: true,
          uniqueness: true

  validates :first_name,
          presence: true

  validates :last_name,
          presence: true

end
