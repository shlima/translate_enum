RSpec.describe ActionView do
  let(:view) do
    Class.new do
      include ActionView::Helpers
      include ActionView::Context
    end.new
  end

  let(:model) do
    Class.new do
      include ActiveModel::Model
      include TranslateEnum

      translate_enum :status

      def self.model_name
        ActiveModel::Name.new(nil, nil, 'model')
      end

      def self.statuses
        { published: 1, removed: 0 }
      end
    end
  end

  describe 'select_tag' do
    subject do
      options_for_select = model.translated_statuses.map { |translation, k, _v| [translation, k] }
      view.select_tag :statuses, view.options_for_select(options_for_select, selected: :published)
    end

    let(:expectation) do <<-HTML.chomp
<select name="statuses" id="statuses"><option selected="selected" value="published">translation missing: en.activemodel.attributes.model.status_list.published</option>
<option value="removed">translation missing: en.activemodel.attributes.model.status_list.removed</option></select>
HTML
    end

    it 'puts value inside hidden option and translation inside visible tag' do
      expect(subject).to eq(expectation)
    end
  end
end
