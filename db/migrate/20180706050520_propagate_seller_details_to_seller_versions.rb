class PropagateSellerDetailsToSellerVersions < ActiveRecord::Migration[5.1]
  def up
    Seller.all.each {|seller|
      seller.propagate_changes_to_version!
    }
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
