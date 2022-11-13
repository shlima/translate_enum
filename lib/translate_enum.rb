# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/string'
require 'translate_enum/version'
require 'translate_enum/builder'

module TranslateEnum
  extend ActiveSupport::Concern

  # include TranslateEnum in ActiveModel or ActiveRecord
  module ClassMethods
    # @example
    #   class User < ActiveRecord::Base
    #     include TranslateEnum
    #     enum status: %i(active archived)
    #     translate_enum :status
    #   end
    #
    #   User.translated_status(:active) #=> "Active translation"
    def translate_enum(attribute, &block)
      builder = Builder.new(self, attribute, &block)

      # User.translated_status(:active)
      define_singleton_method(builder.method_name_singular) do |key|
        I18n.translate("#{builder.i18n_scope}.#{builder.i18n_location(key)}", default: builder.i18n_default_location(key))
      end

      # @return [Array]
      # @example
      #   f.select_field :gender, f.object.class.translated_genders
      define_singleton_method(builder.method_name_plural) do
        public_send(builder.enum_klass_method_name).map do |key, value|
          [public_send(builder.method_name_singular, key), key, value]
        end
      end

      # @return [String]
      # @example
      #   @user.translated_gender
      define_method(builder.method_name_singular) do
        if (key = public_send(builder.enum_instance_method_name)).present?
          self.class.public_send(builder.method_name_singular, key)
        end
      end
    end
  end
end
