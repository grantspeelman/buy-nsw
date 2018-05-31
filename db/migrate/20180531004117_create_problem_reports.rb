class CreateProblemReports < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_reports do |t|
      t.text :task
      t.text :issue
      t.string :url
      t.string :referer
      t.string :browser
      t.integer :user_id
      t.timestamps
    end
  end
end
