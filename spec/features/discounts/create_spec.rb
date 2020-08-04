require 'rails_helper'

RSpec.describe "bulk discount creation page" do
  describe "as merchant employee" do
    before :each do
      @sports = Merchant.create(name: "Santiago's Sporting Goods", address: "45 Nature Bliss St", city: "San Diego", state: "CA", zip: 92102)
      @music = Merchant.create(name: "Marley's Music", address: "1 Mother Nature Cir", city: "San Diego", state: "CA", zip: 92109)

      @chester = @sports.users.create(name: "Chester Cheetah", address: "455 Hot Fiyah Ave", city: "Phoenix",
                            state: "AZ", zip: 85253, email: "hunnidmilesrunnin@gmail.com",
                            password: "123test", password_confirmation: "123test")

      @sports.items.create(name: "Basketball", description: "Ballislife!", price: 30.00,
                          image: "https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2020%2F05%2Fnba-drops-spalding-basketball-for-wilson-2021-season-1.jpg?q=80&w=1000&cbr=1&fit=max",
                          inventory: 25, active: true)
      @sports.items.create(name: "Football", description: "Go long!", price: 25.00,
                          image: "https://dks.scene7.com/is/image/GolfGalaxy/19NIKUVPR24720FFFFTB?qlt=70&wid=992&fmt=pjpeg",
                          inventory: 20, active: true)
      @music.items.create(name: "Victory Lap", description: "By Nipsey Hussle", price: 15.00,
                          image: "https://upload.wikimedia.org/wikipedia/en/thumb/4/46/Nipsey_Hussle_–_Victory_Lap.png/220px-Nipsey_Hussle_–_Victory_Lap.png",
                          inventory: 10, active: true)

      @discount = @sports.discounts.create!(name: "10% off 20 or more items", min_item_quantity: 20, percent_off: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@chester)
    end
    it "allows new bulk discount to be created" do
      visit "/merchant/discounts"

      click_link "New Bulk Discount"
      expect(current_path).to eq("/merchant/discounts/new")

      fill_in :name, with: "15% off 30 or more items"
      fill_in :min_item_quantity, with: 30
      fill_in :percent_off, with: 15
      click_on "Create Bulk Discount"

      new_discount = Discount.last

      expect(page).to have_content("New Bulk Discount Created")
      expect(current_path).to eq("/merchant/discounts")

      expect(page).to have_link(new_discount.name)
      expect(page).to have_content(new_discount.min_item_quantity)
      expect(page).to have_content(new_discount.percent_off)
    end

    it "displays flash error message when information is missing from bulk discount creation form" do
      visit "/merchant/discounts"

      click_link "New Bulk Discount"
      expect(current_path).to eq("/merchant/discounts/new")

      fill_in :name, with: "15% off 30 or more items"
      fill_in :min_item_quantity, with: 30
      fill_in :percent_off, with: ""
      click_on "Create Bulk Discount"

      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Percent off is not a number")
    end
  end
end
