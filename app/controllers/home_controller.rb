class HomeController < ApplicationController
  verify :method => :post, :only => [:upload], :redirect_to => {:action =>:index}
  
  def index
  end
  
  def upload
    redirect_to :action => :index if params[:uploaded_data].blank?
    asset = Asset.new({:image => params[:uploaded_data]})
    @color_codes = asset.convert_to_array_of_colours.map{|x| x.to_s(base=16)}
  end
end
