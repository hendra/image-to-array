class Asset
  require 'RMagick'
  require 'tempfile'
  
  def initialize(incoming_file)
    @round_time = Time.now.to_i.to_s + "." + rand(100000).to_s + "."
    @file_name = @round_time + incoming_file.original_filename.gsub(/.(jpg|JPG|JPEG)/, '.jpeg')
    @original_filename = incoming_file.original_filename
    @content_type = incoming_file.content_type.chomp
    
    if !@content_type.include?('image')
      raise "Is not an image"
    else
      if incoming_file.kind_of?(Tempfile) || (RAILS_ENV == 'test' && incoming_file.kind_of?(ActionController::TestUploadedFile))
        @img = Magick::Image::read(incoming_file.local_path).first
      else
        @img = Magick::Image::from_blob(incoming_file.string).first
      end
      @width, @height = @img.columns, @img.rows
    end
  end
  
  def to_colour_array
      return sort(@img.export_pixels, 'desc')
  end
  
  def sort(array, order='asc')
    rv=[]
    grouped = array.group_by {|i| i}
    sorted = grouped.sort_by{|x| x.last.size}
    sorted.each{|k,v| rv << k}
    rv.reverse! if order.eql?('desc')
    return rv
  end
  
end
