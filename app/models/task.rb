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

  def up_priority
    return false if priority == max_priority
    exchange_priority(1)
  end

  def down_priority
    return false if priority == min_priority
    exchange_priority(-1)
  end

  protected

  def set_max_priority
    self.priority = max_priority + 1
  end

  def max_priority
    project.tasks.maximum(:priority).to_i
  end

  def min_priority
    project.tasks.minimum(:priority).to_i
  end

  def exchange_priority(i)
    tasks = self.project.tasks.order('priority ASC')
    other_task = tasks[ tasks.find_index{ |item| item == self } + i ]
    self.priority, other_task.priority = other_task.priority, self.priority
    Task.transaction do
      self.save!
      other_task.save!
    end
    true
  end

end
