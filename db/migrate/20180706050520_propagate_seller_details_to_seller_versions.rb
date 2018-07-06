class PropagateSellerDetailsToSellerVersions < ActiveRecord::Migration[5.1]
  def up
    Seller.all.each {|seller|
      seller.propagate_changes_to_version!
    }
  end

  def down
    puts "PropagateSellerDetailsToSellerVersions cannot be reversed"
  end
end
