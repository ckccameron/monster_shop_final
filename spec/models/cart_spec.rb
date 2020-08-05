require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 15 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 12 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 2
        })
      @discount = @megan.discounts.create!(name: "10% off 5 or more items", min_item_quantity: 5, percent_off: 10)
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@ogre.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 2,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 2
        })
    end

    it '.count' do
      expect(@cart.count).to eq(5)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant, @hippo])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(220)

      @cart.add_item(@ogre.id.to_s)
      @cart.add_item(@giant.id.to_s)
      expect(@cart.grand_total.round(2)).to eq(261.00)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
    end

    it '.discounted_subtotal_of()' do
      @cart.add_item(@ogre.id.to_s)
      @cart.add_item(@ogre.id.to_s)

      expect(@cart.discounted_subtotal_of(@ogre.id).round(2)).to eq(54.00)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(false)
      expect(@cart.limit_reached?(@hippo.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.items_for_discount()' do

    end
  end
end
