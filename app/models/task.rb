class Task < ApplicationRecord
  include AASM

  belongs_to :project
  has_many :comments

  validates :text, :project_id, :state, presence: true
  validates :text, length: { in: 1..512 }
  validates :priority, numericality: { greater_than: 0, only_integer: true },
                       allow_blank: true
  validates :state, length: { in: 1..64 }
  validates :deadline, date: { allow_blank: true }

  scope :belongs_to_project, ->(project_id) { where(project_id: project_id) }

  aasm column: 'state' do
    state :in_progress, initial: true
    state :done

    event :do do
      transitions from: :in_progress, to: :done
    end

    event :cancel do
      transitions from: :done, to: :in_progress
    end
  end

  before_create :set_max_priority

  protected

  def set_max_priority
    max_priority = self.class.belongs_to_project(self.project_id).maximum(:priority)
    self.priority = max_priority.to_i + 1
  end

end
