class Checkout
    attr_accessor :cart, :total, :status
    
    def initialize
        @cart = []
    end
    
    def to_index(input)
        index = input - 1
    end
    
    def total
       @total = @cart.collect{|item|item[:price]}.inject(:+)
    end

    def shop
        loop do
            self.add_to_cart 
        break if self.status == "exit"
        end
    end

    def new_cart?
        puts "\nWould you like to start a new cart? (Y) or exit? (N)"
        input = gets.chomp.upcase
        while input != "Y" && input != "N"
            puts "\nInvalid response."
            puts "Would you like to start a new cart? (Y) or exit? (N)"
            input = gets.chomp.upcase
        end

        if input == "N"
            self.status = "exit"
        end
    end

    def continue?
        puts "\nWould you like to continue shopping? (Y) or proceed to checkout? (N)"
        input = gets.chomp.upcase
        while input != "Y" && input != "N"
            puts "\nInvalid response."
            puts "Would you like to continue shopping? (Y) or proceed to checkout? (N)"
            input = gets.chomp.upcase
        end
        
        if input == "N"
            self.checkout
        else
            self.add_to_cart
        end
    end

    def add_to_cart
        self.status = "shopping"
        #Category Selection
        CLI.display_categories
        puts "\nSelect the numbered category you wish to shop:"
        input = gets.chomp.to_i
        while !input.between?(1,Category.all.size)
            puts "\nInvalid selection, please select a valid category."
            input = gets.chomp.to_i
        end
        category = Category.all[(self.to_index(input))].name
        
        #Product Selection
        Scraper.scrape_products(category) unless Product.all.collect{|prod| prod.category}.include? (category)
        if Product.products_by_category(category).empty?
            puts "\nNo available products for this category."
            puts "Redirecting to main menu..."
            sleep(1)
            self.status = "shopping"
        else
            CLI.display_products(category)
            puts "\nSelect the numbered product you wish to add to cart:"
            input = gets.chomp.to_i
            while !input.between?(1,Product.products_by_category(category).size)
                puts "\nInvalid selection, please select a valid product."
                input = gets.chomp.to_i
            end
            product = Product.select_by_category(category,self.to_index(input))

            #Style Selection
            CLI.display_styles(product)
            puts "\nSelect the numbered style you wish to purchase:"
            input = gets.chomp.to_i
            while !input.between?(1,product.styles.size)
                puts "\nInvalid selection, please select a valid style."
                input = gets.chomp.to_i
            end
            style = product.select_style(self.to_index(input))
            
            #Size Selection
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

            puts "\nSuccessfully added to cart:"
            puts "#{product.name} - #{style.to_s} - #{size} - #{product.price}"
            self.display_cart
            self.continue?
        end
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
        self.display_cart
        puts "\nAttempting Checkout..."
        sleep(rand()*3)
        puts "Successfully Checked Out!"
        self.empty_cart
        self.new_cart?
    end
end