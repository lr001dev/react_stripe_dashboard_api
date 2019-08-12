class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.datetime :booked_date
      t.integer :user_id
      t.integer :session_id

      t.timestamps
    end
  end
end
