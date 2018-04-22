class MakeEventsUseSti < ActiveRecord::Migration[5.1]
  def change
    change_table :events do |t|
      t.rename :message_type, :type
      t.remove :message_params
      t.string :name
      t.string :email
    end
  end
end
