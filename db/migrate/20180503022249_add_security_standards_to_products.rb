class AddSecurityStandardsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.string :data_centre_security_standards

      t.boolean :iso_27001
      t.string :iso_27001_accreditor
      t.date :iso_27001_date
      t.text :iso_27001_exclusions

      t.boolean :iso_27017
      t.string :iso_27017_accreditor
      t.date :iso_27017_date
      t.text :iso_27017_exclusions

      t.boolean :iso_27018
      t.string :iso_27018_accreditor
      t.date :iso_27018_date
      t.text :iso_27018_exclusions

      t.boolean :csa_star
      t.string :csa_star_accreditor
      t.date :csa_star_date
      t.string :csa_star_level
      t.text :csa_star_exclusions

      t.boolean :pci_dss
      t.string :pci_dss_accreditor
      t.date :pci_dss_date
      t.text :pci_dss_exclusions

      t.boolean :soc_1
      t.boolean :soc_2
    end
  end
end
