class AddAuthorisedRepresentativePositionToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :representative_position, :string
  end
end
