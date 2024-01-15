module Spree
  module Seeds
    class Template
      require 'nokogiri'
      prepend ::Spree::ServiceModule::Base

      TEMPLATES = %i[confirm_email cancel_email store_owner_notification_email shipped_email reimbursement_email]

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
            name: Spree.t(:owner_email_name, scope: :template),
            internal_name: Spree.t(:owner_email, scope: :template),
            active: true,
            content_html: parse_data('store_owner_notification_email.html.erb'),
            content_json: json_data('store_owner_notification_email.json'),
            store_id: current_store.id,
            },
          confirm_email: {
            name: Spree.t(:order_confirm_email_name, scope: :template),
            internal_name: Spree.t(:order_confirm_email, scope: :template),
            active: true,
            content_html: parse_data('confirm_email.html.erb'),
            content_json: json_data('confirm_email.json'),
            store_id:  current_store.id,
          },
          shipped_email: {
            name: Spree.t(:shipment_email_name, scope: :template),
            internal_name: Spree.t(:shipment_email, scope: :template),
            active: true,
            content_html: parse_data('shipped_email.html.erb'),
            content_json: json_data('shipped_email.json'),
            store_id:  current_store.id,
          },
          cancel_email: {
            name: Spree.t(:cancelation_email_name, scope: :template),
            internal_name: Spree.t(:cancelation_email, scope: :template),
            active: true,
            content_html: parse_data('cancel_email.html.erb'),
            content_json: json_data('cancel_email.json'),
            store_id:  current_store.id,
          },
          reimbursement_email: {
            name: Spree.t(:reimbursment_email_name, scope: :template),
            internal_name: Spree.t(:reimbursment_email, scope: :template),
            active: true,
            content_html: parse_data('reimbursement_email.html.erb'),
            content_json: json_data('reimbursement_email.json'),
            store_id:  current_store.id,
          }
        }
        data
      end

      def file_path(file_name, subdirectory = '')
        gem_path = Gem::Specification.find_by_name('spree_email_templates').gem_dir
        File.join(gem_path, 'app', 'services', 'spree', 'email_templates', subdirectory, file_name)
      end

      def parse_data(file_name)
        Nokogiri::HTML(File.open(file_path(file_name))).to_html
      end

      def json_data(file_name)
        JSON.parse(File.read(file_path(file_name, 'json_data')))
      end

    end
  end
end
