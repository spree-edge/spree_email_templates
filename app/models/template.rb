class Template < ApplicationRecord
  belongs_to :store, class_name: '::Spree::Store'
end
