class CreateAlcmsTexts < ActiveRecord::Migration
  def change
    create_table :alcms_texts do |t|
      t.integer :block_id
      t.string :name
      t.text :content
      t.text :content_draft

      t.timestamps null: false
    end

    add_index :alcms_texts, :block_id
    add_index :alcms_texts, :name
  end
end
