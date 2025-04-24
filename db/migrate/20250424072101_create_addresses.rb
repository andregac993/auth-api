class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.string :zip_code, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
