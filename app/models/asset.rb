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

private
  
  def sort(arr, order='asc')
     tmp = {}
     result = []
     arr.uniq.each do |u|
      tmp[u] = 0
      arr.each do |a|
        tmp[u] += 1 if a.eql?(u)
      end
     end
     tmp.sort{|a,b| a[1]<=>b[1]}.each do |t|
      result << t[0]
     end
     
    rv = order.eql?('asc') ? result : result.reverse
    return rv
  end
  
end
