class Scraper
    @@url = "https://www.supremenewyork.com/shop/"

    def self.scrape_categories
        doc = Nokogiri::HTML(open("#{@@url}all"))
        categories = doc.css("ul#nav-categories li")
        puts "Scraping Categories..."
        categories.each do |cat|
            name = cat.css("a").text
            Category.new(name) unless name == "all" || name == "new" || Category.all.detect {|a| a.name == name}
        end

        Category.sort
    end

    def self.scrape_products(category)
        puts "Scraping Products..."

        # Handles category "tops/sweaters" and creates the proper url for that category
        if category.include?("/")
            url = category.gsub("/","_")
        else 
            url = category
        end

        #Parses the respective category webpage HTML
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

            Product.new(name, category) unless Product.products.include?(name) || prod.css("div.inner-article a div.sold_out_tag").text == "sold out"
            Product.all.detect{|product| product.name == name}.add_style(style,link,sizes) unless prod.css("div.inner-article a div.sold_out_tag").text == "sold out"
        end
        Product.sort
    end
end
