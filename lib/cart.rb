class Cart
    attr_accessor :contents, :total
    
    def initialize
        @contents = []
    end
    
    def total
       @total = @contents.collect{|item|item[:price]}.inject(:+)
    end

    def empty_cart
        @contents.clear
    end

end