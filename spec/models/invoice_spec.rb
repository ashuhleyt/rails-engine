require 'rails_helper'

RSpec.describe Invoice, type: :model do 
  describe 'relationships' do 
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have(:items).through(:invoice_items) }
  end
end