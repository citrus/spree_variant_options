require 'spec_helper'

describe Spree::OptionValue do
  let(:option_value) { FactoryBot.create(:option_value) }

  describe 'Associations' do
    it { should have_attached_file(:image) }
  end

  describe 'Validations' do
    it { should validate_attachment_size(:image).less_than(1.megabytes) }
    it { should validate_attachment_content_type(:image).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml') }
  end

  describe 'Instance Methods' do
    describe '#has_image?' do
      context 'when image is assigned to option value' do
        before do
          option_value.image = File.open(Rails.root + '../image/img.png')
        end

        it 'returns true' do
          expect(option_value.has_image?).to eq true
        end
      end

      context 'when image is not assigned to option value' do
        it 'returns false' do
          expect(option_value.has_image?).to eq false
        end
      end
    end
  end
end
