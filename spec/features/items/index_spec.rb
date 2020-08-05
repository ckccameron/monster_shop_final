require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Item Index Page' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @nessie = @brian.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )

      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')

      @order_1 = @user.orders.create!
      @order_2 = @user.orders.create!
      @order_3 = @user.orders.create!

      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 5)
      @order_3.order_items.create!(item: @nessie, price: @nessie.price, quantity: 7)

      @discount_1 = @megan.discounts.create!(name: "10% off 20 or more items", min_item_quantity: 20, percent_off: 10)
      @discount_2 = @megan.discounts.create!(name: "15% off 30 or more items", min_item_quantity: 30, percent_off: 15)
      @discount_3 = @megan.discounts.create!(name: "25% off 40 or more items", min_item_quantity: 40, percent_off: 25)
      @discount_4 = @brian.discounts.create!(name: "10% off 25 or more items", min_item_quantity: 25, percent_off: 10)
      @discount_5 = @sal.discounts.create!(name: "15% off 35 or more items", min_item_quantity: 35, percent_off: 15)
    end
    it 'I can see a list of all active items' do
      visit '/items'

      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_content(@ogre.description)
        expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@ogre.inventory}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_css("img[src*='#{@ogre.image}']")
        expect(page).to have_link("image")
        expect(page).to have_link(@megan.name)
      end

      within "#item-#{@giant.id}" do
        expect(page).to have_link(@giant.name)
        expect(page).to have_content(@giant.description)
        expect(page).to have_content("Price: #{number_to_currency(@giant.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@giant.inventory}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_css("img[src*='#{@giant.image}']")
        expect(page).to have_link("image")
        expect(page).to have_link(@megan.name)
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_link(@hippo.name)
        expect(page).to have_content(@hippo.description)
        expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@hippo.inventory}")
        expect(page).to have_content("Sold by: #{@brian.name}")
        expect(page).to have_css("img[src*='#{@hippo.image}']")
        expect(page).to have_link("image")
        expect(page).to have_link(@brian.name)
      end

      expect(page).to_not have_css("#item-#{@nessie.id}")
    end

    it 'I see the most and least popular items' do
      visit items_path

      within '.statistics' do
        expect(page).to have_content("Most Popular Items:\n#{@hippo.name}: 8 sold #{@ogre.name}: 2 sold #{@giant.name}: 0 sold")
        expect(page).to have_content("Least Popular Items:\n#{@giant.name}: 0 sold #{@ogre.name}: 2 sold #{@hippo.name}: 8 sold")
      end
    end

    it "displays all bulk discounts offered by a merchant" do
      visit items_path

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content(@discount_1.merchant.name)
        expect(page).to have_content(@discount_1.name)
        expect(page).to have_content(@discount_1.min_item_quantity)
        expect(page).to have_content(@discount_1.percent_off)
      end
    end
  end
end
