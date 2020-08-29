class PagesController < ApplicationController

  def home

    @countries = Countries.all

  end

  def validate

  end

end
