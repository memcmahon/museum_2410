require './lib/museum'
require './lib/patron'
require './lib/exhibit'
require 'pry'

RSpec.describe Museum do
    describe '#initialize' do
        it 'creates a new instance' do
            dmns = Museum.new("Denver Museum of Nature and Science")

            expect(dmns).to be_a(Museum)
        end

        it 'set initial attributes' do
            dmns = Museum.new("Denver Museum of Nature and Science")

            expect(dmns.name).to eq("Denver Museum of Nature and Science")
            expect(dmns.exhibits).to eq([])
            expect(dmns.patrons).to eq([])
            expect(dmns.revenue).to eq(0)
            expect(dmns.patrons_of_exhibits).to eq({})
            
        end 
    end

    describe '#add_exhibit' do
        it 'can add instances of exhibits to our exhibits array' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            imax = Exhibit.new({name: "IMAX",cost: 15})

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)

            expect(dmns.exhibits).to eq([gems_and_minerals, dead_sea_scrolls, imax])
        end
    end

    describe '#recommend_exhibits' do
        it 'returns an array of exhibits that match a patrons interests' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            patron_1 = Patron.new("Bob", 20)
            patron_2 = Patron.new("Sally", 20)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)
            patron_1.add_interest("Dead Sea Scrolls")
            patron_1.add_interest("Gems and Minerals")
            patron_2.add_interest("IMAX")

            expect(dmns.recommend_exhibits(patron_1)).to eq([gems_and_minerals, dead_sea_scrolls])
            expect(dmns.recommend_exhibits(patron_2)).to eq([imax])
        end

        # verify that if a person has no matching interests/exhibits, returns empty? or nil?
    end

    describe '#admit' do
        it 'adds patron to our array of patrons' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            patron_1 = Patron.new("Bob", 20)
            patron_2 = Patron.new("Sally", 20)

            dmns.admit(patron_1)
            dmns.admit(patron_2)

            expect(dmns.patrons).to eq([patron_1, patron_2])
        end 

        it 'admits patrons who cannot afford any exhibits' do 
            dmns = Museum.new("Denver Museum of Nature and Science")
            imax = Exhibit.new({name: "IMAX",cost: 15})
            tj = Patron.new("TJ", 7)
            tj.add_interest("IMAX")
            dmns.add_exhibit(imax)

            dmns.admit(tj)

            expect(dmns.patrons).to eq([tj])
            expect(dmns.revenue).to eq(0)
            expect(dmns.patrons_of_exhibits).to eq({})
        end

        it 'admits patrons who can afford one of their interested exhibits' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            tj = Patron.new("TJ", 7)
            bob = Patron.new("Bob", 10)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(imax)
            dmns.add_exhibit(dead_sea_scrolls)

            tj.add_interest("IMAX")
            tj.add_interest("Dead Sea Scrolls")
            bob.add_interest("Dead Sea Scrolls")
            bob.add_interest("IMAX")

            dmns.admit(tj)
            dmns.admit(bob)

            expected_patrons_of_exhibits = {
                dead_sea_scrolls => [bob]
            }

            expect(dmns.patrons).to eq([tj, bob])
            expect(bob.spending_money).to eq(0)
            expect(dmns.revenue).to eq(10)
            expect(dmns.patrons_of_exhibits).to eq(expected_patrons_of_exhibits)
        end

        it 'admits patrons in order of exhibit cost (desc) who can afford multiple (but not all) of their interested exhibits' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            tj = Patron.new("TJ", 7)
            bob = Patron.new("Bob", 10)
            sally = Patron.new("Sally", 20)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)

            tj.add_interest("IMAX")
            tj.add_interest("Dead Sea Scrolls")
            bob.add_interest("Dead Sea Scrolls")
            bob.add_interest("IMAX")
            sally.add_interest("IMAX")
            sally.add_interest("Dead Sea Scrolls")

            dmns.admit(tj)
            dmns.admit(bob)
            dmns.admit(sally)

            expected_patrons_of_exhibits = {
                dead_sea_scrolls => [bob],
                imax => [sally]
            }

            expect(dmns.patrons).to eq([tj, bob, sally])
            expect(sally.spending_money).to eq(5)
            expect(dmns.revenue).to eq(25)
            expect(dmns.patrons_of_exhibits).to eq(expected_patrons_of_exhibits)
        end

        it 'admits patrons in order of exhibit cost (desc) who can afford all of their interested exhibits' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            tj = Patron.new("TJ", 7)
            bob = Patron.new("Bob", 10)
            sally = Patron.new("Sally", 20)
            morgan = Patron.new("Morgan", 15)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)

            tj.add_interest("IMAX")
            tj.add_interest("Dead Sea Scrolls")
            bob.add_interest("Dead Sea Scrolls")
            bob.add_interest("IMAX")
            sally.add_interest("IMAX")
            sally.add_interest("Dead Sea Scrolls")
            morgan.add_interest("Gems and Minerals")
            morgan.add_interest("Dead Sea Scrolls")

            dmns.admit(tj)
            dmns.admit(bob)
            dmns.admit(sally)
            dmns.admit(morgan)

            expected_patrons_of_exhibits = {
                dead_sea_scrolls => [bob, morgan],
                imax => [sally],
                gems_and_minerals => [morgan]
            }

            expect(dmns.patrons).to eq([tj, bob, sally, morgan])
            expect(morgan.spending_money).to eq(5)
            expect(dmns.revenue).to eq(35)
            expect(dmns.patrons_of_exhibits).to eq(expected_patrons_of_exhibits)
        end
    end

    describe '#patrons_by_exhibit_interest' do
        it 'return a hash grouping patrons into exhibits they are interested in' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            patron_1 = Patron.new("Bob", 0)
            patron_2 = Patron.new("Sally", 20)
            patron_3 = Patron.new("Johnny", 5)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)

            patron_1.add_interest("Gems and Minerals")
            patron_1.add_interest("Dead Sea Scrolls")
            patron_2.add_interest("Dead Sea Scrolls")
            patron_3.add_interest("Dead Sea Scrolls")
            
            dmns.admit(patron_1)
            dmns.admit(patron_2)
            dmns.admit(patron_3)

            expected = {
                gems_and_minerals => [patron_1],
                dead_sea_scrolls => [patron_1, patron_2, patron_3],
                imax => []
            }

            expect(dmns.patrons_by_exhibit_interest).to eq(expected)
        end
    end

    describe '#ticket_lottery_contestants' do
        it 'returns an array of qualified patrons' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            patron_1 = Patron.new("Bob", 0)
            patron_2 = Patron.new("Sally", 20)
            patron_3 = Patron.new("Johnny", 5)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)

            patron_1.add_interest("Gems and Minerals")
            patron_1.add_interest("Dead Sea Scrolls")
            patron_2.add_interest("Dead Sea Scrolls")
            patron_3.add_interest("Dead Sea Scrolls")
            
            dmns.admit(patron_1)
            dmns.admit(patron_2)
            dmns.admit(patron_3)

            expect(dmns.ticket_lottery_contestants(dead_sea_scrolls)).to eq([patron_1, patron_3])
        end
    end

    describe '#draw_lottery_winner' do
        it 'returns the name of the patron who has won the lottery' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            patron_1 = Patron.new("Bob", 0)
            patron_2 = Patron.new("Sally", 20)
            patron_3 = Patron.new("Johnny", 5)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)

            patron_1.add_interest("Gems and Minerals")
            patron_1.add_interest("Dead Sea Scrolls")
            patron_2.add_interest("Dead Sea Scrolls")
            patron_3.add_interest("Dead Sea Scrolls")
            
            dmns.admit(patron_1)
            dmns.admit(patron_2)
            dmns.admit(patron_3)

            winner = dmns.draw_lottery_winner(dead_sea_scrolls)

            expect(winner).to be_a(String)
            expect(["Johnny", "Bob"].include?(winner)).to eq(true)
            expect(winner).to_not eq("Sally")
        end

        it 'returns nil if no patrons qualify for the lottery' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
            dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
            imax = Exhibit.new({name: "IMAX",cost: 15})
            patron_1 = Patron.new("Bob", 0)
            patron_2 = Patron.new("Sally", 20)
            patron_3 = Patron.new("Johnny", 5)

            dmns.add_exhibit(gems_and_minerals)
            dmns.add_exhibit(dead_sea_scrolls)
            dmns.add_exhibit(imax)

            patron_1.add_interest("Gems and Minerals")
            patron_1.add_interest("Dead Sea Scrolls")
            patron_2.add_interest("Dead Sea Scrolls")
            patron_3.add_interest("Dead Sea Scrolls")
            
            dmns.admit(patron_1)
            dmns.admit(patron_2)
            dmns.admit(patron_3)

            winner = dmns.draw_lottery_winner(gems_and_minerals)

            expect(winner).to eq(nil)
        end
    end

    describe 'announce_lottery_winner' do
        it 'should return a string announcing the winners name and exhibit' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            imax = Exhibit.new({name: "IMAX",cost: 15})

            allow(dmns).to receive(:draw_lottery_winner) { "Bob" }

            expect(dmns.announce_lottery_winner(imax)).to eq("Bob has won the IMAX edhibit lottery")
        end

        it 'should return a string indicating no winners if no contestants exist' do
            dmns = Museum.new("Denver Museum of Nature and Science")
            imax = Exhibit.new({name: "IMAX",cost: 15})

            allow(dmns).to receive(:draw_lottery_winner) { nil }

            expect(dmns.announce_lottery_winner(imax)).to eq("No winners for this lottery")
        end
    end
end