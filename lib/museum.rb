class Museum
    attr_reader :name, 
                :exhibits, 
                :patrons,
                :revenue,
                :patrons_of_exhibits

    def initialize(name)
        @name = name
        @exhibits = []
        @patrons = []
        @revenue = 0
        @patrons_of_exhibits = {}
    end

    def add_exhibit(exhibit)
        @exhibits << exhibit
    end

    def admit(patron)
        @patrons << patron

        recommended_exhibits_ordered_by_price = recommend_exhibits(patron).sort_by do |exhibit|
            exhibit.cost
        end.reverse

        recommended_exhibits_ordered_by_price.each do |exhibit|
            if patron.spending_money >= exhibit.cost
                patron.spending_money -= exhibit.cost
                @revenue += exhibit.cost
                @patrons_of_exhibits[exhibit] = [] if @patrons_of_exhibits[exhibit].nil?
                @patrons_of_exhibits[exhibit] << patron
            end
        end
    end

    def recommend_exhibits(patron)
        # if time: refactor to use find_all
        matching_exhibits = []
        @exhibits.each do |exhibit|
            # if time: refactor so that patron responds to: patron.is_interested?(exhibit.name)
            if patron.interests.include?(exhibit.name)
                matching_exhibits << exhibit
            end
        end
        matching_exhibits
    end

    def patrons_by_exhibit_interest
        grouped_patrons = {}
        @exhibits.each do |exhibit|
            grouped_patrons[exhibit] = []
            @patrons.each do |patron|
                # if time: refactor so that patron responds to: patron.is_interested?(exhibit.name)
                if patron.interests.include?(exhibit.name)
                    grouped_patrons[exhibit] << patron
                end
            end
        end
        grouped_patrons
    end

    def ticket_lottery_contestants(exhibit)
        interested_patrons = patrons_by_exhibit_interest[exhibit]
        interested_patrons.find_all do |patron|
            patron.spending_money < exhibit.cost
        end 
    end

    def draw_lottery_winner(exhibit)
        contestants = ticket_lottery_contestants(exhibit)
        return nil if contestants.empty?
        contestants.sample.name
    end

    def announce_lottery_winner(exhibit)
        return "No winners for this lottery" if draw_lottery_winner(exhibit).nil?
        "#{draw_lottery_winner(exhibit)} has won the #{exhibit.name} edhibit lottery"
    end
end