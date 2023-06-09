require "rails_helper"

RSpec.describe "the mechanic's show page" do
  let!(:amusement_park_1) { AmusementPark.create!(name: "Six Flags", admission_cost: 75) }

  let!(:ride_1) { amusement_park_1.rides.create!(name: "The Hurler", thrill_rating: 7, open: true) }
  let!(:ride_2) { amusement_park_1.rides.create!(name: "The Scrambler", thrill_rating: 4, open: true) }
  let!(:ride_3) { amusement_park_1.rides.create!(name: "Ferris Wheel", thrill_rating: 7, open: false) }

  let!(:mechanic_1) { Mechanic.create!(name: "Sam Mills", years_experience: 10) }
  let!(:mechanic_2) { Mechanic.create!(name: "Kara Smith", years_experience: 11) }

  before(:each) do
    RideMechanic.create!(ride: ride_1, mechanic: mechanic_1)
    RideMechanic.create!(ride: ride_2, mechanic: mechanic_1)

    visit mechanic_path(mechanic_1)
  end

  it "displays their name and years of experience" do
    within("#page-title") do
      expect(page).to have_content(mechanic_1.name)
      expect(page).to have_content("Years of Experience: #{mechanic_1.years_experience}")

      expect(page).not_to have_content(mechanic_2.name)
    end
  end

  it "displays the names of all rides they're currently working on" do
    within("#current-rides") do
      expect(page).to have_content("Current rides they're working on:")
      expect(page).to have_content(ride_1.name)
      expect(page).to have_content(ride_2.name)

      expect(page).not_to have_content(ride_3.name)
    end
  end

  it "displays a form to add a ride to the mechanic's workload by ride id" do
    expect(page).not_to have_content(ride_3.name)

    within("#add-ride") do
      expect(page).to have_content("Add a ride to workload by Ride ID:")
      expect(page).to have_field(:ride_id)
      expect(page).to have_button("Submit")
    end

    fill_in :ride_id, with: ride_3.id

    click_button "Submit"

    expect(current_path).to eq(mechanic_path(mechanic_1))

    within("#current-rides") do
      expect(page).to have_content(ride_3.name)
    end
  end
end
