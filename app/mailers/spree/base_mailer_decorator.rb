module Spree
  module BaseMailerDecorator

    private

    def build_template(resource, options = {})
      return unless template.present?

      @body = template.render_body(resource, options)
    end

    def template
      current_store.templates.find_by(name: action_name)
    end

  end
end

::Spree::BaseMailer.prepend ::Spree::BaseMailerDecorator
