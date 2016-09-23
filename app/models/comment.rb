class Comment < ApplicationRecord

  belongs_to :task

  validates :text, :task_id, presence: true
  validates :text, length: { in: 1..1024 }

end
