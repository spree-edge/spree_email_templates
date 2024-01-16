class CreateTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :templates do |t|
      t.string :name
      t.string :internal_name
      t.text :content_html
      t.json :content_json
      t.boolean :active
      t.integer :store_id

      t.timestamps
    end
  end
end
