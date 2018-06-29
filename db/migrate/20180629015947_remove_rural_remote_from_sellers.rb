class RemoveRuralRemoteFromSellers < ActiveRecord::Migration[5.1]
  def up
    # Any seller who said they were rural/remote in the new definition of
    # regional (outside metro) should have regional set now.
    execute <<-SQL
      UPDATE sellers SET regional = TRUE WHERE rural_remote = TRUE
    SQL
    remove_column :sellers, :rural_remote, :boolean
  end
end
