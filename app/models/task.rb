class Task < ApplicationRecord
  include AASM

  belongs_to :project
  has_many :comments

  validates :text, :project_id, :priority, :state, presence: true
  validates :text, length: { in: 1..512 }
  validates :priority, numericality: { greater_than: 0, only_integer: true }
  validates :state, length: { in: 1..64 }
  validates :deadline, date: true

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

end
