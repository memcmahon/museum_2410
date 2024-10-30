class Exhibit
    attr_reader :name, :cost

    def initialize(exhibit_info)
        @name = exhibit_info[:name]
        @cost = exhibit_info[:cost]
    end
end