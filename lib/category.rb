class Category
    attr_reader :name
    @@all = []

    def initialize(category)
        @name = category.capitalize
        @@all << self
    end

    def self.categories
        @@all.collect {|a| a.name}
    end

    def self.sort
        @@all = @@all.sort_by{|cat| cat.name}

    end

    def self.all
        @@all
    end

    def self.clear
        @@all.clear
    end

end

