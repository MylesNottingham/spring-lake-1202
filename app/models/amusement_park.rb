class AmusementPark < ApplicationRecord
  has_many :rides, dependent: :destroy
  has_many :mechanics, through: :rides

  # instance methods
  def names_of_mechanics_working
    mechanics.distinct.pluck(:name)
  end
end
