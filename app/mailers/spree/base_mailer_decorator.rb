module Spree
  module BaseMailerDecorator

    private

    def build_template(resource, options = {})
      @template = current_store.templates.find_by(name: action_name)
      return unless @template.present?

      @body = @template.render_body(resource, options)
    end

  end
end

::Spree::BaseMailer.prepend ::Spree::BaseMailerDecorator
