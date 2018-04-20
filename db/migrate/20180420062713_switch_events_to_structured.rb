class SwitchEventsToStructured < ActiveRecord::Migration[5.1]
  def change
    change_table :events do |t|
      t.remove :description
      t.string :message_type, null: false
      t.text   :message_params
    end
  end
end
