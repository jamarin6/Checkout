require 'checkout'
require 'item'

RSpec.describe Checkout do

	before :each do 
    @checkout = Checkout.new
  end

	describe "at the beginning" do
		it "have an empty list items" do
			expect(@checkout.items).to be_empty
		end

		it "total is 0" do
			expect(@checkout.total).to eq("Total: 0.00€")
		end
	end

	describe ".scan" do
		it "adds the item that you scan" do
			@checkout.scan("VOUCHER")
			expect(@checkout.items.size).to eq(1)
			expect(@checkout.items.first).to have_attributes(:code => "VOUCHER", :name => "Cabify Voucher", :price => 5)
		end

		it "invalid items scanned are not added" do
			@checkout.scan("FAKE")
			expect(@checkout.items.size).to eq(0)
		end
	end

	describe "several items scan action" do
  	before :each do
			@checkout.scan("VOUCHER")
  		@checkout.scan("VOUCHER")
  		@checkout.scan("VOUCHER")
  	end

  	it "adds items that you scan" do
			expect(@checkout.items.size).to eq(3)
			expect(@checkout.items[0]).to have_attributes(:code => "VOUCHER", :name => "Cabify Voucher", :price => 5)
			expect(@checkout.items[1]).to have_attributes(:code => "VOUCHER", :name => "Cabify Voucher", :price => 5)
			expect(@checkout.items[2]).to have_attributes(:code => "VOUCHER", :name => "Cabify Voucher", :price => 5)
		end

  	it "not contain items not selected" do
  		@checkout.items.each do |item|
    		expect(item).not_to have_attributes(:code => "TSHIRT")
    		expect(item).not_to have_attributes(:code => "MUG")
    	end
  	end
  end

  describe ".voucher_discount" do
  	it "discount does not return with 0 items" do
  		expect(@checkout.voucher_discount(@checkout.items)).to eq(0)
  	end

  	it "discount does not return with 1 items" do
  		@checkout.scan("VOUCHER")
  		expect(@checkout.voucher_discount(@checkout.items)).to eq(0)
  	end

  	it "work with ODD quantities, qty=3" do
    	@checkout.scan("VOUCHER")
    	@checkout.scan("VOUCHER")
    	@checkout.scan("VOUCHER")
      expect(@checkout.voucher_discount(@checkout.items)).to eq(@checkout.items.first.price)
    end

    it "return correct discount with EVEN vouchers, qty=4" do
    	@checkout.scan("VOUCHER")
    	@checkout.scan("VOUCHER")
    	@checkout.scan("VOUCHER")
    	@checkout.scan("VOUCHER")
      expect(@checkout.voucher_discount(@checkout.items)).to eq(@checkout.items.first.price * 2)
    end
  end

  describe ".tshirt_discount" do
  	it "return 0 discount if you scan 0 tshirts" do
  		expect(@checkout.tshirt_discount(@checkout.items)).to eq(0)
  	end

  	it "return 0 discount if you scan 1 tshirt" do
  		@checkout.scan("TSHIRT")
  		expect(@checkout.tshirt_discount(@checkout.items)).to eq(0)
  	end

  	it "return 0 discount if you scan 2 tshirts" do
  		@checkout.scan("TSHIRT")
  		@checkout.scan("TSHIRT")
  		expect(@checkout.tshirt_discount(@checkout.items)).to eq(0)
  	end

  	it "return discount of 1€ for each unit if you scan 3 tshirts" do
  		@checkout.scan("TSHIRT")
  		@checkout.scan("TSHIRT")
  		@checkout.scan("TSHIRT")
  		expect(@checkout.tshirt_discount(@checkout.items)).to eq(@checkout.items.size)
  	end

  	it "return 1€ discount for each item if you scan three or more units" do
    	5.times { @checkout.scan("TSHIRT") }
    	expect(@checkout.tshirt_discount(@checkout.items)).to eq(@checkout.items.size)
    end
  end

  describe ".mug_discount" do
  	it "return 0 discount when you scan several mugs" do
  		18.times { @checkout.scan("MUG") }
  		expect(@checkout.mug_discount(@checkout.items)).to eq(0)
  	end
  end

  describe ".total" do # proposed examples
  	it "return 'Total: 32.50€' when you scan VOUCHER, TSHIRT, MUG" do
  		@checkout.scan("VOUCHER")
  		@checkout.scan("TSHIRT")
  		@checkout.scan("MUG")
  		expect(@checkout.total).to eq("Total: 32.50€")
  	end

  	it "return 'Total: 25.00€' when you scan VOUCHER, TSHIRT, VOUCHER" do
  		@checkout.scan("VOUCHER")
  		@checkout.scan("TSHIRT")
  		@checkout.scan("VOUCHER")
  		expect(@checkout.total).to eq("Total: 25.00€")
  	end

  	it "return 'Total: 81.00€' when you scan TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT" do
  		@checkout.scan("TSHIRT")
  		@checkout.scan("TSHIRT")
  		@checkout.scan("TSHIRT")
  		@checkout.scan("VOUCHER")
  		@checkout.scan("TSHIRT")
  		expect(@checkout.total).to eq("Total: 81.00€")
  	end

  	it "return 'Total: 74.50€' when you scan VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT" do
  		@checkout.scan("VOUCHER")
  		@checkout.scan("TSHIRT")
  		@checkout.scan("VOUCHER")
  		@checkout.scan("VOUCHER")
  		@checkout.scan("MUG")
  		@checkout.scan("TSHIRT")
  		@checkout.scan("TSHIRT")
  		expect(@checkout.total).to eq("Total: 74.50€")
  	end
  end
end