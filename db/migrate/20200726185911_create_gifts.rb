class CreateGifts < ActiveRecord::Migration[6.0]
  def change
    create_table :gifts do |t|
      t.string :from, null: false, comment: "The gift givers name"
      t.text :message, comment: "The gift givers optional message to a child"
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
