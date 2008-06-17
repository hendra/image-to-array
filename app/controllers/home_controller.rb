class HomeController < ApplicationController
  verify :method => :post, :only => [:upload], :redirect_to => {:action =>:index}
  
  def index
  end
  
  def upload
    redirect_to :action => :index if params[:uploaded_data].blank?
    asset = Asset.new(params[:uploaded_data])
    @color_codes = asset.to_colour_array
  end
end
