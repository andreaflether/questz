# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#notyf_classes_for' do
    it { expect(helper.notyf_classes_for('success')).to eq('success') }
    it { expect(helper.notyf_classes_for('error')).to eq('error') }
    it { expect(helper.notyf_classes_for('alert')).to eq('warning') }
    it { expect(helper.notyf_classes_for('notice')).to eq('info') }
  end

  describe '#custom_flash_messages' do
    context 'when flash message is present' do
      before { controller.flash[:success] = 'Success!' }

      it {
        expect(helper.custom_flash_messages).to eq("<script>$(document).ready(function() {$.notyf.open({ type: 'success', message: 'Success!'})})</script>")
      }

      it { expect(flash.to_h).not_to have_key(:success) }
    end

    context 'when flash message is not present' do
      it { expect(helper.custom_flash_messages).to be_blank }
    end
  end

  describe '#format_datetime' do 
    it { expect(helper.format_datetime(Date.parse('1997-11-13'))).to eq('Nov 13, 1997')}
  end

  describe '#user_vote' do 

  end
end
