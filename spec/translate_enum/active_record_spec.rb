RSpec.describe 'ActiveRecord::Base', order: :defined do
  subject do
    require 'translate_enum/active_record'
  end

  context 'ActiveRecord is undefined' do
    it 'raises an error' do
      expect { subject }.to raise_error(NameError)
    end
  end

  context 'ActiveRecord defined' do
    let(:active_record_class) do
      Class.new
    end

    before do
      stub_const('ActiveRecord::Base', active_record_class)
    end

    it 'extends ActiveRecord' do
      expect { subject }.to change { ActiveRecord::Base.respond_to?(:translate_enum) }.to true
    end
  end
end
