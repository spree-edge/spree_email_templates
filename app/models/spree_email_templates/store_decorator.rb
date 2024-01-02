module SpreeEmailTemplates
  module StoreDecorator
    def self.prepended(base)
      base.has_many :templates, class_name: '::Template'
      private
      def create_email_template
        Spree::Seeds::Template.call(self)
      end
    end
  end
end
::Spree::Store.prepend ::SpreeEmailTemplates::StoreDecorator
