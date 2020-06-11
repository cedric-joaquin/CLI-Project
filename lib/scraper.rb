class Scraper
    @@url = "https://www.supremenewyork.com/shop/"

    # Creates categories available on the Supreme website
    def self.scrape_categories
        doc = Nokogiri::HTML(open("#{@@url}all"))
        categories = doc.css("ul#nav-categories li")
        puts "Scraping Categories..."
        categories.each do |cat|
            Category.new(cat.css("a").text) unless cat.css("a").text == "all" || cat.css("a").text == "new"
        end

        Category.sort
        puts "Categories:"
        Category.all.each_with_index {|cat, i| puts "#{i+1}. #{cat.name}"}
    end

    # Scrapes in-stock products and stores its name and category
    def self.scrape_products
        puts "Scraping Products..."
        Category.categories.each do |cat|
            # Handles category "tops/sweaters" and creates the proper url for that category
            if cat.include?("/")
                url = cat.gsub("/","_")
            else 
                url = cat
            end

            doc = Nokogiri::HTML(open(@@url + "all/#{url}"))

            products = doc.css("ul#container li")

            products.each do |prod|
                name = prod.css("div.product-name").text
                name = prod.css("div.product-name").text
                style = prod.css("div.product-style").text
                link = prod.css("div.product-style a").attr("href").value
                link = link.gsub("/shop","")

                doc = Nokogiri::HTML(open(@@url + link))
                sizes = doc.css("div#cctrl select option").collect{|options| options.text}

                Product.new(name, cat) unless Product.products.include?(name) || prod.css("div.inner-article a div.sold_out_tag").text == "sold out"
                #Product.all.detect{|product| product.name == name}.add_style(style,link,sizes) unless prod.css("div.inner-article a div.sold_out_tag").text == "sold out"
            end
        end
        Product.all
    end

    # def self.styles(product)
    #     Category.categories.each do |cat|
    #         # Handles category "tops/sweaters" and creates the proper url for that category
    #         cat = cat.gsub("/","_") if cat.include?("/")
    #         doc = Nokogiri::HTML(open(@@url + "all/#{cat}"))

    #         products = doc.css("ul#container li")

    #         products.each do |prod|
    #             name = prod.css("div.product-name").text
    #             style = prod.css("div.product-style").text
    #             link = prod.css("div.product-style a").attr("href").value
    #             link = link.gsub("/shop","")

    #             #Accessing the specific product webpage and pulls the sizes available
    #             doc = Nokogiri::HTML(open(@@url + link))
    #             sizes = doc.css("div#cctrl select option").collect{|options| options.text}

    #             Product.all.detect{|product| product.name == name}.add_style(style,link,sizes)
    #         end
    #     end
    # end



end
