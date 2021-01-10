# frozen_string_literal: true

module TranslateEnum
  # Global configuration support for TranslateEnum
  #   TranslateEnum.configure do |config|
  #     config.i18n_scope = 'translate_enum'
  #   end
  class << self
    def configure
      yield config
    end

    def config
      @_config ||= Config.new
    end
  end

  class Config
    attr_accessor :i18n_scope

    def initialize
      @i18n_scope = nil
    end
  end
end
