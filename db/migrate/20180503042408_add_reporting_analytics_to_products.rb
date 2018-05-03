class AddReportingAnalyticsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.text :outage_channel_types, default: [], array: true
      t.text :outage_channel_other

      t.text :metrics_contents
      t.text :metrics_channel_types, default: [], array: true
      t.text :metrics_channel_other

      t.text :usage_channel_types, default: [], array: true
      t.text :usage_channel_other
    end
  end
end
