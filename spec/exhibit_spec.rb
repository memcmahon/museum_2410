require './lib/exhibit'

RSpec.describe Exhibit do
    describe '#initialize' do
        it 'creates a new instance' do
            exhibit = Exhibit.new({name: "Gems and Minerals", cost: 0})

            expect(exhibit).to be_a(Exhibit)
        end

        it 'sets initial attributes' do
            exhibit = Exhibit.new({name: "Gems and Minerals", cost: 0})

            expect(exhibit.name).to eq("Gems and Minerals")
            expect(exhibit.cost).to eq(0)
        end
    end 
end