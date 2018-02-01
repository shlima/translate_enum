RSpec.describe TranslateEnum do
  let(:model_base) do
    Class.new do
      include ActiveModel::Model
      include TranslateEnum

      def self.model_name
        ActiveModel::Name.new(nil, nil, 'model')
      end

      def self.genders
        { male: 0, female: 1 }
      end

      def gender
        @gender ||= :male
      end

      def gender=(value)
        @gender = value
      end
    end
  end

  subject do
    model.new
  end

  context 'default' do
    let(:model) do
      Class.new(model_base) do
        translate_enum :gender
      end
    end

    let(:translations) do
      {
        male: 'I am a default of the male',
        female: 'Female (not default)'
      }
    end

    before do
      I18n.backend.store_translations(:en, attributes: { gender_list: { male: translations.fetch(:male) } })
      I18n.backend.store_translations(:en, activemodel: { attributes: { model: { gender_list: { female: translations.fetch(:female) } } } })
    end

    after do
      I18n.reload!
    end

    it 'uses default path as a fallback' do
      expect(model.translated_gender(:male)).to eq(translations.fetch(:male))
      expect(model.translated_gender(:female)).to eq(translations.fetch(:female))
    end
  end

  context 'default options' do
    let(:model) do
      Class.new(model_base) do
        translate_enum :gender
      end
    end

    let(:translations) do
      {
        male: 'translation missing: en.activemodel.attributes.model.gender_list.male',
        female: 'translation missing: en.activemodel.attributes.model.gender_list.female'
      }
    end

    it '#translated_gender' do
      expect(subject.gender).to eq(:male)

      expect { subject.gender = :female }.to change {
        subject.translated_gender
      }.from(translations.fetch(:male)).to(translations.fetch(:female))

      expect(subject.gender).to eq(:female)
    end

    it '.translated_gender' do
      expect(model.translated_gender(:male)).to eq(translations.fetch(:male))
      expect(model.translated_gender(:female)).to eq(translations.fetch(:female))
    end

    it '.translated_genders' do
      expectation = [
        [translations.fetch(:male), :male, 0],
        [translations.fetch(:female), :female, 1]
      ]
      expect(model.translated_genders).to match_array(expectation)
    end
  end

  context 'redefined options' do
    let(:model) do
      Class.new(model_base) do
        translate_enum :gender do |config|
          config.i18n_scope = 'scope'
          config.i18n_key = 'key'
          config.enum_klass_method_name = 'my_genders_method'
          config.enum_instance_method_name = 'my_gender_method'
          config.method_name_singular = 'russian_gender'
          config.method_name_plural = 'russian_genders'
        end

        class << self
          undef :genders
        end

        undef :gender
        undef :gender=

        def self.my_genders_method
          { male: 0, female: 1 }
        end

        def my_gender_method
          @my_gender_method ||= :male
        end

        def my_gender_method=(value)
          @my_gender_method = value
        end
      end
    end

    let(:translations) do
      {
        male: 'translation missing: en.scope.model.key.male',
        female: 'translation missing: en.scope.model.key.female'
      }
    end

    it '.russian_gender' do
      expect(model.russian_gender(:male)).to eq(translations.fetch(:male))
      expect(model.russian_gender(:female)).to eq(translations.fetch(:female))
    end

    it '.russian_genders' do
      expectation = [
        [translations.fetch(:male), :male, 0],
        [translations.fetch(:female), :female, 1]
      ]
      expect(model.russian_genders).to match_array(expectation)
    end

    it '#russian_gender' do
      expect(subject.russian_gender).to eq(translations.fetch(:male))
    end
  end

  context 'redefined methods' do
    let(:model) do
      Class.new(model_base) do
        translate_enum :gender

        def self.translated_gender(key)
          "foo_bar_#{key}"
        end
      end
    end

    it 'returns redefined value' do
      expect(subject.translated_gender).to eq('foo_bar_male')
    end
  end
end
