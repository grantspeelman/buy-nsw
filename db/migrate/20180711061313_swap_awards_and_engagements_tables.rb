class SwapAwardsAndEngagementsTables < ActiveRecord::Migration[5.1]
  def change
    # This will basically just swap all the data in seller_awards
    # and seller_engagements
    rename_table :seller_awards, :seller_awards_new
    rename_table :seller_engagements, :seller_awards
    rename_table :seller_awards_new, :seller_engagements
    rename_column :seller_awards, :engagement, :award
    rename_column :seller_engagements, :award, :engagement
  end
end
