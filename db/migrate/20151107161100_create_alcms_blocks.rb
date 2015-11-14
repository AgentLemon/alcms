class CreateAlcmsBlocks < ActiveRecord::Migration
  def change
    create_table :alcms_blocks do |t|
      t.string :name
      t.datetime :starts_at
      t.datetime :expires_at
      t.integer :origin_block_id

      t.timestamps null: false
    end

    add_index :alcms_blocks, :name
  end
end
