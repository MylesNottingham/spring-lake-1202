require "rails_helper"

RSpec.describe AmusementPark, type: :model do
  describe "relationships" do
    it { should have_many(:rides) }
    it { should have_many(:mechanics).through(:rides) }
  end

  describe "instance methods" do
    let!(:amusement_park_1) { AmusementPark.create!(name: "Six Flags", admission_cost: 75) }

    let!(:ride_1) { amusement_park_1.rides.create!(name: "The Hurler", thrill_rating: 7, open: true) }
    let!(:ride_2) { amusement_park_1.rides.create!(name: "The Scrambler", thrill_rating: 4, open: true) }
    let!(:ride_3) { amusement_park_1.rides.create!(name: "Ferris Wheel", thrill_rating: 7, open: false) }

    let!(:mechanic_1) { Mechanic.create!(name: "Sam Mills", years_experience: 10) }
    let!(:mechanic_2) { Mechanic.create!(name: "Kara Smith", years_experience: 11) }
    let!(:mechanic_3) { Mechanic.create!(name: "Christian Bale", years_experience: 5) }

    let!(:ride_mechanic_1) { RideMechanic.create!(ride: ride_1, mechanic: mechanic_1) }
    let!(:ride_mechanic_2) { RideMechanic.create!(ride: ride_2, mechanic: mechanic_1) }
    let!(:ride_mechanic_3) { RideMechanic.create!(ride: ride_3, mechanic: mechanic_2) }

    describe "#mechanics_working" do
      it "returns a list of unique mechanics working at the amusement park" do
        expect(amusement_park_1.names_of_mechanics_working.sort).to eq([mechanic_1.name, mechanic_2.name].sort)
      end
    end
  end
end
