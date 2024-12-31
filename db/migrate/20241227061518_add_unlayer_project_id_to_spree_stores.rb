class AddUnlayerProjectIdToSpreeStores < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_stores, :unlayer_project_id, :string
  end
end
