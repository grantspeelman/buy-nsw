class ChangeSecurityStandardsFieldsOnProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :soc_1, :boolean
    change_table :products do |t|
      t.string :soc_2_accreditor
      t.date :soc_2_date
      t.text :soc_2_exclusions

      t.string :irap_type
      t.boolean :asd_certified
      t.text :security_classification_types, array: true, default: []
      t.string :security_information_url
    end
  end
end
