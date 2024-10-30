require './lib/patron'

RSpec.describe Patron do
    describe '#initialize' do
        it 'creates a new instance' do
            patron = Patron.new("Bob", 20)

            expect(patron).to be_a(Patron)
        end

        it 'sets initial attributes' do
            patron = Patron.new("Bob", 20)

            expect(patron.name).to eq("Bob")
            expect(patron.spending_money).to eq(20)
            expect(patron.interests).to eq([])
        end

        it 'allows spending_money to be changed' do
            patron = Patron.new("Bob", 20)

            patron.spending_money = 10

            expect(patron.spending_money).to eq(10)
        end
    end 

    describe '#add_interest' do
        it "add an interest to our interests array" do
            patron = Patron.new("Bob", 20)
            patron.add_interest("Dead Sea Scrolls")
            patron.add_interest("Gems and Minerals")

            expected = ["Dead Sea Scrolls", "Gems and Minerals"]

            expect(patron.interests).to eq(expected)
        end
    end
end