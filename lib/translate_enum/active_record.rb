# Require this fle in order to be +TranslateEnum+ included in +ActiveRecord::Base+
# @example
#   require 'translate_enum/active_record'

require_relative '../translate_enum'

unless defined?(ActiveRecord::Base)
  raise NameError, 'TranslateEnum requires ActiveRecord be defined but it is not'
end

ActiveRecord::Base.include(TranslateEnum)
