class Asset < ActiveRecord::Base
  require 'RMagick'
  require 'tempfile'
  
  def image=(incoming_file)
    @round_time = Time.now.to_i.to_s + "." + rand(100000).to_s + "."
    @file_name = @round_time + incoming_file.original_filename.gsub(/.(jpg|JPG|JPEG)/, '.jpeg')
    @original_filename = incoming_file.original_filename
    @content_type = incoming_file.content_type.chomp
    
    if !@content_type.include?('image')
      @img = incoming_file.read    
    else
      if incoming_file.kind_of?(Tempfile) || 
         (RAILS_ENV == 'test' && incoming_file.kind_of?(ActionController::TestUploadedFile))
        @img = Magick::Image::read(incoming_file.local_path).first
      else
        @img = Magick::Image::from_blob(incoming_file.string).first
      end
      @width, @height = @img.columns, @img.rows
    end
  end
  
  def convert_to_array_of_colours
    if @content_type.include?('image')
      return @img.export_pixels
    else
      return []
    end
  end
  
end
