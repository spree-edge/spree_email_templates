class AddLocalToTemplate < ActiveRecord::Migration[6.1]
  def change
    add_column :templates, :locale, :string, default: "en"
  end
end
