class Product
    attr_accessor :styles
    attr_reader :name, :sizes, :category, :price
    @@all = []

    def initialize(name, category, price)
        @name = name
        @category = category
        @price = price
        @styles = []
        @@all << self
    end

    def add_style(style)
        @styles << style
    end

    def self.sort
        @@all = @@all.sort_by{|cat| cat.name}
    end

    def self.products
        @@all.collect {|a| a.name}
    end

    def self.all
        @@all
    end

end