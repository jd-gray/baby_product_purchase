require 'rails_helper'

RSpec.feature "Purchase Product", type: :feature do
  before do
    @product = Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12,
    )

    visit "/"

    within ".products-list .product" do
      click_on "More Details…"
    end

    click_on "Buy Now $10.00"
  end

  describe "order form" do
    context "when user successfully checks out" do
      scenario "Creates an order and charges us" do
        fill_in "order[credit_card_number]", with: "4111111111111111"
        fill_in "order[expiration_month]", with: 12
        fill_in "order[expiration_year]", with: 25
        fill_in "order[shipping_name]", with: "Pat Jones"
        fill_in "order[address]", with: "123 Any St"
        fill_in "order[zipcode]", with: 83701
        fill_in "order[child_full_name]", with: "Kim Jones"
        fill_in "order[child_birthdate]", with: "2019-03-03"

        click_on "Purchase"

        expect(page).to have_content("Thanks for Your Order")
        expect(page).to have_content(Order.last.user_facing_id)
        expect(page).to have_content("Kim Jones")
      end
    end

    context "when user unsuccessfully checks out" do
      scenario "Tells us when there was a problem charging our card" do
        fill_in "order[credit_card_number]", with: "4242424242424242"
        fill_in "order[expiration_month]", with: 12
        fill_in "order[expiration_year]", with: 25
        fill_in "order[shipping_name]", with: "Pat Jones"
        fill_in "order[address]", with: "123 Any St"
        fill_in "order[zipcode]", with: 83701
        fill_in "order[child_full_name]", with: "Kim Jones"
        fill_in "order[child_birthdate]", with: "2019-03-03"

        click_on "Purchase"

        expect(page).not_to have_content("Thanks for Your Order")
        expect(page).to have_content("Problem with your order")
        expect(page).to have_content(Order.last.user_facing_id)
        expect(page).to have_content("Kim Jones")
      end
    end
  end

  describe "order form with gift" do
    before do
      child = Child.create!(
        full_name: "Caliah Gray",
        birthdate: Date.new(2020,6,17),
        parent_name: "Jared Gray",
      )
      previous_order = Order.create!(
        product: @product,
        child: child,
        user_facing_id: SecureRandom.uuid[0..7],
        shipping_name: "Jared Gray",
        address: "1396 W Park",
        zipcode: "85233",
        paid: true,
      )
    end

    context "when user successfully checks out" do
      scenario "Creates an order as a gift and charges us" do
        click_on "Is this a gift?"

        fill_in "order[credit_card_number]", with: "4111111111111111"
        fill_in "order[expiration_month]", with: 12
        fill_in "order[expiration_year]", with: 25
        fill_in "order[shipping_name]", with: "Jared Gray"
        fill_in "order[from]", with: "Grandpa"
        fill_in "order[message]", with: 83701
        fill_in "order[child_full_name]", with: "Caliah Gray"
        fill_in "order[child_birthdate]", with: "2020-06-17"

        click_on "Purchase"

        expect(page).to have_content("Thanks for Your Order")
        expect(page).to have_content(Order.last.user_facing_id)
        expect(page).to have_content("Caliah Gray")
        expect(Gift.all.size).to eq(1)
      end
    end

    context "when user unsuccessfully checks out" do
      scenario "Attempts to create an order with a child that doesn't exist" do
        click_on "Is this a gift?"

        fill_in "order[credit_card_number]", with: "4111111111111111"
        fill_in "order[expiration_month]", with: 12
        fill_in "order[expiration_year]", with: 25
        fill_in "order[shipping_name]", with: "Rachel Gray"
        fill_in "order[from]", with: "Grandpa"
        fill_in "order[message]", with: 83701
        fill_in "order[child_full_name]", with: "Cruz Gray"
        fill_in "order[child_birthdate]", with: "2020-06-17"

        click_on "Purchase"

        expect(page).not_to have_content("Thanks for Your Order")
        expect(page).to have_content("Child could not be found, please try another search!")
        expect(Order.last.shipping_name).not_to eq("Rachel Gray")
        expect(Gift.all.size).not_to eq(1)
      end
    end
  end
end
