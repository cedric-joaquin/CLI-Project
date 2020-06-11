class CLI

    def self.to_index(input)
        index = input - 1
    end

    def self.display_categories
        puts "\nCategories:"
        Category.all.each_with_index {|cat, i| puts "#{i+1}. #{cat.name}"}
    end

    def self.display_products(category)
        puts "\nAvailable Products in #{category.capitalize}:"
        Product.all.select{|a| a.category == category}.each_with_index do |prod, i|
            puts "#{i+1}. #{prod.name}"
        end
    end

end