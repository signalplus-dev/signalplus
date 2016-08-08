module ApplicationHelper
  IMAGE_ASSET_REGEX = /(?<=\/images\/).+\.(png|jpg|svg|gif)$/

  # @return [Hash<String, String>] A key-value pair of the image assets coming from the Rails
  #                                asset pipeline.
  def image_assets
    @image_assets ||= Dir["#{Rails.root}/app/assets/images/**/**"].inject({}) do |hash, file|
      image_file = file[IMAGE_ASSET_REGEX]

      if image_file
        image_asset = image_url(image_file)
        key         = image_file.gsub(/\/|\-|\./, '_').camelize(:lower)
        hash[key]   = image_asset
      end

      hash
    end
  end
end
