module SpreeEmailTemplates
  module LineItemDecorator

    def custom_fields
      {
        'single_money' => single_money.to_s,
        'display_amount' => display_amount.to_s,
        'options_text' => variant.options_text,
        'name' => name
      }
    end

  end
end

::Spree::LineItem.prepend ::SpreeEmailTemplates::LineItemDecorator
