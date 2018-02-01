module TranslateEnum
  class Builder
    attr_accessor :i18n_scope
    attr_accessor :i18n_key

    attr_accessor :enum_instance_method_name
    attr_accessor :enum_klass_method_name

    attr_accessor :method_name_singular
    attr_accessor :method_name_plural

    attr_reader :model, :attribute

    # @param model [ActiveModel::Model, ActiveRecord::Base]
    # @param attribute [String]
    def initialize(model, attribute)
      @model = model
      @attribute = attribute
      yield(self) if block_given?
    end

    # like "activerecord.attributes" or "activemodel.attributes"
    def i18n_scope
      @i18n_scope ||= "#{model.i18n_scope}.attributes"
    end

    def i18n_key
      @i18n_key ||= "#{attribute}_list"
    end

    def i18n_location(key)
      "#{model.model_name.i18n_key}.#{i18n_key}.#{key}"
    end

    def i18n_default_location(key)
      :"attributes.#{i18n_key}.#{key}"
    end

    # @param [String]
    # like "translated_genders"
    def method_name_plural
      @method_name_plural ||= "translated_#{attribute.to_s.pluralize}"
    end

    # @param [String]
    # like "translated_gender"
    def method_name_singular
      @method_name_singular ||= "translated_#{attribute.to_s.singularize}"
    end

    def enum_klass_method_name
      @enum_klass_method_name ||= attribute.to_s.pluralize
    end

    def enum_instance_method_name
      @enum_instance_method_name ||= attribute
    end
  end
end
