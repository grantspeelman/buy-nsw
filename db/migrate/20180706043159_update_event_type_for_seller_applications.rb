class UpdateEventTypeForSellerApplications < ActiveRecord::Migration[5.1]
  def up
    Event::Event.where(eventable_type: 'SellerApplication').update_all(eventable_type: 'SellerVersion')
  end

  def down
    Event::Event.where(eventable_type: 'SellerVersion').update_all(eventable_type: 'SellerApplication')
  end
end
