require 'tempfile'
module SimpleCaptcha #:nodoc
  module ImageHelpers #:nodoc

    DISTORTIONS = ['low', 'medium', 'high']

    class << self

      def image_params(color = '#0089d1')
        ["-alpha set -background none -fill \"#{color}\""]
      end

      def distortion(key='low')
        key =
          key == 'random' ?
          DISTORTIONS[rand(DISTORTIONS.length)] :
          DISTORTIONS.include?(key) ? key : 'low'
        case key.to_s
          when 'low' then return [0 + rand(2), 80 + rand(20)]
          when 'medium' then return [2 + rand(2), 50 + rand(20)]
          when 'high' then return [4 + rand(2), 30 + rand(20)]
        end
      end
    end

    if RUBY_VERSION < '1.9'
      class Tempfile < ::Tempfile
        # Replaces Tempfile's +make_tmpname+ with one that honors file extensions.
        def make_tmpname(basename, n = 0)
          extension = File.extname(basename)
          sprintf("%s,%d,%d%s", File.basename(basename, extension), $$, n, extension)
        end
      end
    end

    private

      def generate_simple_captcha_image(simple_captcha_key) #:nodoc
        amplitude, frequency = ImageHelpers.distortion(SimpleCaptcha.distortion)
        text = Utils::simple_captcha_new_value(simple_captcha_key)
        params = ImageHelpers.image_params(SimpleCaptcha.image_color).dup
        params << "-size #{SimpleCaptcha.image_size} xc:transparent"
        params << "-gravity \"Center\""
        if params.join(' ').index('-pointsize').nil?
          params << "-pointsize 35"
        end
        dst = Tempfile.new(RUBY_VERSION < '1.9' ? 'simple_captcha.png' : ['simple_captcha', '.png'], SimpleCaptcha.tmp_path)
        dst.binmode
        text.split(//).each_with_index do |letter, index|
          i = -60 + (index*25) + rand(-6..6)
          params << "-draw \"translate #{i},#{rand(-6..6)} skewX #{rand(-15..15)} gravity center text 0,0 '#{letter}'\" "
        end

        params << "-wave #{amplitude}x#{frequency}"

        (1..10).each do |i|
          params << "-draw \"polyline #{rand(160)},#{rand(61)} #{rand(160)},#{rand(62)}\""
        end

        params << "\"#{File.expand_path(dst.path)}\""
        # puts "convert " +  params.join(' ')
        SimpleCaptcha::Utils::run("convert", params.join(' '))

        dst.close

        File.expand_path(dst.path)
        #dst
      end
  end
end
