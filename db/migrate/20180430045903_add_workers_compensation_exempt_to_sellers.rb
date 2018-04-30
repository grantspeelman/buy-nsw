class AddWorkersCompensationExemptToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :workers_compensation_exempt, :boolean, default: false
  end
end
