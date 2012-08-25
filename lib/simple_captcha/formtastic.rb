require "formtastic"

class SimpleCaptchaInput
  include ::Formtastic::Inputs::Base
  
  def to_html
    input_wrapping do
      input_html_options.update :object => method
      label_html << builder.show_simple_captcha(input_html_options)
    end
  end
end