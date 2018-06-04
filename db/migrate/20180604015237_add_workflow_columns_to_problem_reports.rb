class AddWorkflowColumnsToProblemReports < ActiveRecord::Migration[5.1]
  def change
    change_table :problem_reports do |t|
      t.string :state
      t.text :tags, array: true, default: []
      t.integer :resolved_by_id
      t.datetime :resolved_at
    end
  end
end
