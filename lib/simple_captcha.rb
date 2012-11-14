# encoding: utf-8

module SimpleCaptcha
  autoload :Utils,             'simple_captcha/utils'

  autoload :ImageHelpers,      'simple_captcha/image'
  autoload :ViewHelper,        'simple_captcha/view'
  autoload :ControllerHelpers, 'simple_captcha/controller'
  autoload :ModelHelpers,      'simple_captcha/active_record'

  autoload :FormBuilder,       'simple_captcha/form_builder'
  autoload :CustomFormBuilder, 'simple_captcha/formtastic'

  autoload :SimpleCaptchaData, 'simple_captcha/simple_captcha_data'
  autoload :Middleware,        'simple_captcha/middleware'

  mattr_accessor :image_size
  @@image_size = "100x28"

  mattr_accessor :length
  @@length = 5

  mattr_accessor :image_color
  @@image_color = '#0089d1'

  # 'low', 'medium', 'high', 'random'
  mattr_accessor :distortion
  @@distortion = 'low'

  # command path
  mattr_accessor :image_magick_path
  @@image_magick_path = ''

  # tmp directory
  mattr_accessor :tmp_path
  @@tmp_path = nil

  def self.setup
    yield self
  end
end

require 'simple_captcha/engine' if defined?(Rails)
