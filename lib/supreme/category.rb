class Supreme::Category
    attr_reader :name
    @@all = []

    def initialize(category)
        @name = category.capitalize
        @@all << self
        @@all = @@all.sort_by{|cat| cat.name}
    end

    def self.select(index)
        self.all[index].name
    end

    def self.all
        @@all
    end

    def self.clear
        @@all.clear
    end
end

