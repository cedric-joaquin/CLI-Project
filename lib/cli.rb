class CLI
    def self.display_categories
        puts "\nCategories:"
        Category.all.each_with_index {|cat, i| puts "  #{i+1}. #{cat.name}"}
    end

    def self.display_products(category)
        puts "\nAvailable Products in #{category.capitalize}:"
        Product.all.select{|a| a.category == category}.each_with_index do |prod, i|
            puts "  #{i+1}. #{prod.name} - #{prod.price}"
        end
    end

    def self.display_styles(product)
        puts "\nAvailable Styles for '#{product}"
        Product.all.select{|a| a.name == product}.each do |prod|
            prod.styles.collect.keys[0].each_with_index do |style, i|
                puts "  #{i+1}. #{style.to_s}"
            end
        end
    end

    def self.display_sizes(product, style)
        puts "\n Available Sizes for #{product} - #{style}"
        Product.all.select{|a| a.name == product}.each do |prod|
            prod.styles.find{|a| a.has_key?(style)}[style].each_with_index do |size, i|
                puts "  #{i+1}. #{size}."
            end
        end
    end
end