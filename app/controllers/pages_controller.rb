class PagesController < ApplicationController

  def home

    countries = Countries.all
    @country_list = countries.collect { |item|
      [item[:name], item[:alias]]
    }

  end

  def validate

    # Australin ABN Number: 51 824 753 556
    # EU VAT Number:        DE345789003
    #                       IE6388047V
    #                       LU21416127

  end

end
