class Task < ApplicationRecord

  belongs_to :project
  has_many :comments

  validates :text, :project_id, :priority, :state, presence: true
  validates :text, length: { in: 1..512 }
  validates :priority, numericality: { greater_than: 0, only_integer: true }
  validates :state, length: { in: 1..64 }
  validates :deadline, date: true

end
