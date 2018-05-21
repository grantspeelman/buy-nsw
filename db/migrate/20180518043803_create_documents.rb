class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.integer :documentable_id, null: false
      t.string :documentable_type, null: false

      t.string :document
      t.string :kind, null: false
      t.string :scan_status, null: false, default: 'unscanned'

      t.string :original_filename
      t.string :content_type

      t.timestamps
    end
    remove_column :sellers, :financial_statement, :string
    remove_column :sellers, :professional_indemnity_certificate, :string
    remove_column :sellers, :workers_compensation_certificate, :string
  end
end
