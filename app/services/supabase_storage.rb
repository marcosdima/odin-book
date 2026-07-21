require "aws-sdk-s3"
require "securerandom"

class SupabaseStorage
  BUCKET = Rails.application.credentials.supabase[:bucket]

  def self.upload(file, creator_id, folder: "avatars")
    credentials = Rails.application.credentials.supabase
    client = Aws::S3::Client.new(
      access_key_id: credentials[:access_key_id],
      secret_access_key: credentials[:secret_access_key],
      endpoint: credentials[:endpoint],
      region: credentials[:region],
      force_path_style: true
    )

    filename = "user_#{creator_id}.webp"
    key = "#{folder}/#{filename}"

    processed = ImageProcessing::MiniMagick
      .source(file.tempfile)
      .loader(background: "none")
      .resize_to_fill(500, 500)
      .saver(quality: 85)
      .convert("webp")
      .call

    client.put_object(
      bucket: BUCKET,
      key: key,
      body: processed,
      content_type: "image/webp"
    )

    "#{credentials[:uploads_url]}/#{key}"
  end
end
