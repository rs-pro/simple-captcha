require "formtastic"

class SimpleCaptchaInput
  include ::Formtastic::Inputs::Base
  include ::Formtastic::Inputs::Base::Stringish
  
  def to_html
    input_wrapping do
      input_html_options.update :object => method
      label_html << builder.show_simple_captcha(input_html_options)
      # label_html << builder.text_field(method, input_html_options)
    end
  end
end