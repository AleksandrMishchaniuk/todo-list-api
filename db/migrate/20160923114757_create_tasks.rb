class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.text            :text
      t.belongs_to      :project
      t.integer         :priority
      t.string          :state
      t.date            :deadline
      t.timestamps
    end
  end
end
