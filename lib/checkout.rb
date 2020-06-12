class Checkout
    attr_accessor :cart, :total
    
    def initialize
        @cart = []
    end
    
    def to_index(input)
        index = input - 1
    end
    
    def total
       @total = @cart.collect{|item|item[:price]}.inject(:+)
    end

    def add_to_cart
        CLI.display_categories
        puts "\nSelect the numbered category you wish to shop:"
        input = gets.chomp.to_i
        while !input.between?(1,Category.all.size)
            puts "\nInvalid selection, please select a valid category."
            input = gets.chomp.to_i
        end
        category = Category.all[(self.to_index(input))].name
        
        Scraper.scrape_products(category)
        CLI.display_products(category)
        puts "\nSelect the numbered product you wish to add to cart:"
        input = gets.chomp.to_i
        while !input.between?(1,Product.products_by_category(category).size)
            puts "\nInvalid selection, please select a valid product."
            input = gets.chomp.to_i
        end
        product = Product.select_by_category(category,self.to_index(input))

        CLI.display_styles(product)
        puts "\nSelect the numbered style you wish to purchase:"
        input = gets.chomp.to_i
        while !input.between?(1,product.styles.size)
            puts "\nInvalid selection, please select a valid style."
            input = gets.chomp.to_i
        end
        style = product.select_style(self.to_index(input))
        
        CLI.display_sizes(product, style)
        puts "\nSelect the numbered size you wish to purchase:"
        input = gets.chomp.to_i
        while !input.between?(1, product.styles.find{|a|a.has_key?(style)}[style].size)
            puts "\nInvalid selection, please select a valid size."
            input = gets.chomp.to_i
        end
        size = product.styles.find{|a|a.keys[0] == style}[style][self.to_index(input)]
        
        @cart << {
            :product => product.name,
            :style => style.to_s,
            :size => size,
            :price => product.price.gsub("$","").to_i
        }

        puts "Successfully added to cart:"
        puts "#{product.name} - #{style.to_s} - #{size} - #{product.price}"
        self.display_cart

 
    end

    def display_cart
        puts "\nCart Summary:"
        @cart.each_with_index do |item, i| 
            puts "#{i+1}. #{item[:product]} - #{item[:style]} - #{item[:size]} - $#{item[:price].to_s}"
        end
        puts "\nTotal: $#{self.total}"
    end

    def empty_cart
        @cart.clear
    end

    def checkout
        puts "Successfully Checked Out!"
        self.empty_cart
    end
end