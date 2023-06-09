require "rails_helper"

RSpec.describe "the amusement park's show page" do
  let!(:amusement_park_1) { AmusementPark.create!(name: "Six Flags", admission_cost: 75) }

  let!(:ride_1) { amusement_park_1.rides.create!(name: "The Hurler", thrill_rating: 7, open: true) }
  let!(:ride_2) { amusement_park_1.rides.create!(name: "The Scrambler", thrill_rating: 4, open: true) }
  let!(:ride_3) { amusement_park_1.rides.create!(name: "Ferris Wheel", thrill_rating: 7, open: false) }

  let!(:amusement_park_2) { AmusementPark.create!(name: "Universal Studios", admission_cost: 80) }

  let!(:ride_4) { amusement_park_2.rides.create!(name: "Jaws", thrill_rating: 5, open: true) }
  let!(:ride_5) { amusement_park_2.rides.create!(name: "Back to the Future", thrill_rating: 9, open: true) }

  let!(:mechanic_1) { Mechanic.create!(name: "Sam Mills", years_experience: 10) }
  let!(:mechanic_2) { Mechanic.create!(name: "Kara Smith", years_experience: 11) }
  let!(:mechanic_3) { Mechanic.create!(name: "Christian Bale", years_experience: 5) }

  before(:each) do
    RideMechanic.create!(ride: ride_1, mechanic: mechanic_1)
    RideMechanic.create!(ride: ride_2, mechanic: mechanic_1)
    RideMechanic.create!(ride: ride_3, mechanic: mechanic_2)
    RideMechanic.create!(ride: ride_4, mechanic: mechanic_2)
    RideMechanic.create!(ride: ride_5, mechanic: mechanic_3)
  end

  context "when on amusement park 1's show page" do
    before(:each) do
      visit amusement_park_path(amusement_park_1)
    end

    it "displays the name and price of admission" do
      within("#page-title") do
        expect(page).to have_content(amusement_park_1.name)
        expect(page).to have_content("Price of Admission: $#{amusement_park_1.admission_cost}")

        expect(page).not_to have_content(amusement_park_2.name)
      end
    end

    it "displays a list of the unique names of all the mechanics that are working on any rides at that park" do
      within("#mechanics") do
        expect(page).to have_content("Mechanics Currently Working:")
        expect(page).to have_content(mechanic_1.name, count: 1)
        expect(page).to have_content(mechanic_2.name, count: 1)

        expect(page).not_to have_content(mechanic_3.name)
      end
    end
  end

  context "when on amusement park 2's show page" do
    before(:each) do
      visit amusement_park_path(amusement_park_2)
    end

    it "displays the name and price of admission" do
      within("#page-title") do
        expect(page).to have_content(amusement_park_2.name)
        expect(page).to have_content("Price of Admission: $#{amusement_park_2.admission_cost}")

        expect(page).not_to have_content(amusement_park_1.name)
      end
    end

    it "displays a list of the unique names of all the mechanics that are working on any rides at that park" do
      within("#mechanics") do
        expect(page).to have_content("Mechanics Currently Working:")
        expect(page).to have_content(mechanic_2.name, count: 1)
        expect(page).to have_content(mechanic_3.name, count: 1)

        expect(page).not_to have_content(mechanic_1.name)
      end
    end
  end
end
