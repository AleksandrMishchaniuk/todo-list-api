class Project < ApplicationRecord

  belongs_to :user
  has_many :tasks

  validates :title, :user_id, presence: true
  validates :title, length: { in: 1..256 }

end
