class DropBookings < ActiveRecord::Migration[6.0]
  def change
    drop_table :bookings
    drop_table :bookeddates
  end
end
