module Spree
  module Seeds
    class Template
      require 'nokogiri'
      prepend ::Spree::ServiceModule::Base

      TEMPLATES = %i[cancel_email shipped_email confirm_email store_owner_notification_email reimbursement_email]

      def call(store= nil)
        stores = ::Spree::Store.where(id: store.id) if store.present?
        stores = ::Spree::Store.all  if store.nil?
        return unless stores.any?

        stores.each do |store|            
          TEMPLATES.each do |template|
            ::Template.create(template_data(store)[template])
          end
        end
      end

      def template_data(current_store)
        data = { 
          store_owner_notification_email: { 
            name: "store_owner_notification_email",
            active: true,
            content_html: parse_data('store_owner_notification_email.html.erb'),
            content_json: parse_data('store_owner_notification_email.html.erb').to_json,
            store_id: current_store.id,
            },
          confirm_email: {
            name: "confirm_email",
            active: true,
            content_html: parse_data('confirm_email.html.erb'),
            content_json: parse_data('confirm_email.html.erb').to_json,
            store_id:  current_store.id,
          },
          shipped_email: {
            name: "shipped_email",
            active: true,
            content_html: parse_data('shipped_email.html.erb'),
            content_json: parse_data('shipped_email.html.erb').to_json,
            store_id:  current_store.id,
          },
          cancel_email: {
            name: "cancel_email",
            active: true,
            content_html: parse_data('cancel_email.html.erb'),
            content_json: parse_data('cancel_email.html.erb').to_json,
            store_id:  current_store.id,
          },
          reimbursement_email: {
            name: "reimbursement_email",
            active: true,
            content_html: parse_data('reimbursement_email.html.erb'),
            content_json: parse_data('reimbursement_email.html.erb').to_json,
            store_id:  current_store.id,
          }

        }

        data
      end

      def parse_data(file_name)
        gem_path = Gem::Specification.find_by_name('spree_email_templates').gem_dir
        file_path = File.join(gem_path, 'app', 'services', 'spree', 'email_templates', file_name)
        Nokogiri::HTML(File.open(file_path)).to_html
      end

    end
  end
end
