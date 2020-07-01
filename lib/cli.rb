class CLI
    attr_accessor :status
    attr_reader :session

    def initialize
        puts "Welcome to the Supreme Auto Checkout App!"
        Scraper.scrape_categories
        @session = Cart.new
        @status = "shopping"
    end

    def shop
        loop do
            self.add_to_cart 
        break if self.status == "exit"
        end
        puts "\nThank you for using the Supreme Auto Checkout App!"
    end

    def add_to_cart
        #Category Selection
        self.display_categories
        puts "\nSelect the numbered category you wish to shop:"
        input = gets.chomp.to_i
        while !input.between?(1,Category.all.size)
            puts "\nInvalid selection, please select a valid category."
            input = gets.chomp.to_i
        end
        category = Category.select(CLI.to_index(input))
        
        #Product Selection
        Scraper.scrape_products(category) unless Product.all.collect{|prod| prod.category}.include? (category)
        if Product.products_by_category(category).empty?
            puts "\nNo available products for this category."
            puts "Redirecting to main menu..."
            sleep(1)
            self.status = "shopping"
        else
            self.display_products(category)
            puts "\nSelect the numbered product you wish to add to cart:"
            input = gets.chomp.to_i
            while !input.between?(1,Product.products_by_category(category).size)
                puts "\nInvalid selection, please select a valid product."
                input = gets.chomp.to_i
            end
            product = Product.select_by_category(category,CLI.to_index(input))

            #Style Selection
            self.display_styles(product)
            puts "\nSelect the numbered style you wish to purchase:"
            input = gets.chomp.to_i
            while !input.between?(1,product.styles.size)
                puts "\nInvalid selection, please select a valid style."
                input = gets.chomp.to_i
            end
            style = product.select_style(CLI.to_index(input))
            
            #Size Selection
            self.display_sizes(product, style)
            puts "\nSelect the numbered size you wish to purchase:"
            input = gets.chomp.to_i
            while !input.between?(1, product.styles.find{|a|a.keys[0] == style}[style].size)
                puts "\nInvalid selection, please select a valid size."
                input = gets.chomp.to_i
            end
            size = product.styles.find{|a|a.keys[0] == style}[style][CLI.to_index(input)]
            
            session.contents << {
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
            self.status = "shopping"
        end
    end
    
    def checkout
        self.display_cart
        puts "\nAttempting Checkout..."
        sleep(rand()*3)
        puts "Successfully Checked Out!"
        session.empty_cart
        self.new_cart?
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
    
    def display_cart
        puts "\nCart Summary:"
        session.contents.each_with_index do |item, i| 
            puts "#{i+1}. #{item[:product]} - #{item[:style]} - #{item[:size]} - $#{item[:price].to_s}"
        end
        puts "\nTotal: $#{session.total}"
    end


    def display_categories
        puts "\nCategories:"
        Category.all.each_with_index {|cat, i| puts "  #{i+1}. #{cat.name}"}
    end

    def display_products(category)
        puts "\nAvailable Products in #{category.capitalize}:"
        Product.all.select{|a| a.category == category}.each_with_index do |prod, i|
            puts "  #{i+1}. #{prod.name} - #{prod.price}"
        end
    end

    def display_styles(product)
        puts "\nAvailable Styles for #{product.name}:"
        Product.all.select{|a| a.name == product.name}.each do |prod|
            prod.styles.collect{|a| a.keys[0]}.each_with_index do |style, i|
                puts "  #{i+1}. #{style.to_s}"
            end
        end
    end

    def display_sizes(product, style)
        puts "\nAvailable Sizes for #{product.name} - #{style}:"
        Product.all.select{|a| a.name == product.name}.each do |prod|
            prod.styles.find{|a| a.has_key?(style)}[style].each_with_index do |size, i|
                puts "  #{i+1}. #{size}"
            end
        end
    end

    def self.to_index(input)
        index = input - 1
    end

end