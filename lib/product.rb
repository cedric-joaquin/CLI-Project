class Product
    attr_accessor :styles
    attr_reader :name, :category, :price
    @@all = []

    def initialize(name, category, price)
        @name = name
        @category = category
        @price = price
        @styles = []
        @@all << self
        @@all = @@all.sort_by{|prod| prod.name}
    end

    def add_style(style)
        @styles << style
    end

    def select_style(index)
        self.styles[index].keys[0]
    end

    def self.products
        @@all.collect {|a| a.name}
    end

    def self.select_by_category(category, index)
        self.products_by_category(category)[index]
    end

    def self.products_by_category(category)
        @@all.select{|prod| prod.category == category}
    end

    def self.all
        @@all
    end

end