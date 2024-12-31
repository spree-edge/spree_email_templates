class AddEmailTemplatesToStores < ActiveRecord::Migration[6.1]
  def change
    Spree::Seeds::Template.call
  end
end
