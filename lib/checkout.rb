require 'item'

class Checkout

	attr_accessor :items

	def initialize(pricing_rules = [])
		@items = []
	end

	def scan(code_item)
		if (code_item=="VOUCHER")
			@items << Item.new("VOUCHER", "Cabify Voucher", 5)
		elsif (code_item=="TSHIRT")
			@items << Item.new("TSHIRT", "Cabify T-Shirt", 20)
		elsif (code_item=="MUG")
			@items << Item.new("MUG", "Cabify Coffee Mug", 7.5)
		else
		end
	end

	def total
		grouped_items = @items.group_by(&:code) # items grouped by "code" for calculate the discount of each
		initial_price = @items.map(&:price).inject(:+) # price without discount
		total_discount = voucher_discount(grouped_items["VOUCHER"]).to_i + tshirt_discount(grouped_items["TSHIRT"]).to_i + mug_discount(grouped_items["MUG"]).to_i
		final_total = "%.2f" % [initial_price.to_f - total_discount]
		result = "Total: " + final_total.to_s + "€"
	end

	def voucher_discount(vouchers)
		(vouchers.size/2) * 5 if vouchers
	end

	def tshirt_discount(tshirts)
		return 0 unless tshirts
		return 0 unless tshirts.size >= 3
		return tshirts.size * 1 if tshirts.size >=3
	end

	def mug_discount(mugs)
		return 0
	end
end