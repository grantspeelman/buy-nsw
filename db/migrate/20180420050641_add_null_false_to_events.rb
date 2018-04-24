class AddNullFalseToEvents < ActiveRecord::Migration[5.1]
  def change
    change_column_null :events, :description,    false
    change_column_null :events, :eventable_id,   false
    change_column_null :events, :eventable_type, false
  end
end
