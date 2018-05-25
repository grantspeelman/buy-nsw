class ChangeDefaultForWorkersCompensationExpiry < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:sellers, :workers_compensation_exempt, from: false, to: nil)
  end
end
