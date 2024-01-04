module Spree
  module BaseMailerDecorator
    def self.prepended(base)
      base.before_action :find_template
    end

    private

    def find_template
      template = Template.find_by(name: action_name, store_id: current_store)
      @custom_body = template.content_html
    end

  end
end

::Spree::BaseMailer.prepend ::Spree::BaseMailerDecorator
