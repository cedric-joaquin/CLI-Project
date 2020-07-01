class Supreme::Scraper
    @@url = "https://www.supremenewyork.com/shop/"

    def self.scrape_categories
        doc = Nokogiri::HTML(open("#{@@url}all"))
        categories = doc.css("ul#nav-categories li")
        categories.each do |cat|
            name = cat.css("a").text
            Supreme::Category.new(name) unless name == "all" || name == "new" || Supreme::Category.all.detect {|a| a.name == name}
        end
    end

    def self.scrape_products(category)
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
            name = prod.css("div.product-name").text.strip
            
            link = prod.css("div.product-style a").attr("href").value
            link = link.gsub("/shop","")

            doc = Nokogiri::HTML(open(@@url + link))
            if doc.css("div#cctrl select option").collect{|options| options.text}.empty?
                sizes = ["One Size"]
            else
                sizes = doc.css("div#cctrl select#s option").collect{|options| options.text}
            end
                price = doc.css("div#container p.price").text

            style = {
                prod.css("div.product-style").text.to_sym => sizes,
                :link => link
            }
            
            unless prod.css("div.inner-article a div.sold_out_tag").text == "sold out"
                Supreme::Product.new(name, category, price) if !Supreme::Product.products.include?(name) 
                Supreme::Product.all.detect{|product| product.name == name}.add_style(style) 
            end
        end
    end
end