require "aws-sdk-s3"
require "securerandom"

class SupabaseStorage
  BUCKET = Rails.application.credentials.supabase[:bucket]

  class AvatarUploadError < StandardError; end

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

    processed = begin
      ImageProcessing::MiniMagick
        .source(file.tempfile)
        .loader(background: "none")
        .resize_to_fill(500, 500)
        .saver(quality: 85)
        .convert("webp")
        .call
    rescue MiniMagick::Error, ImageProcessing::Error => e
      Rails.logger.error("[AvatarUploader] fail processing image for user #{creator_id}: #{e.message}")
      raise AvatarUploadError, "Could not process the image"
    end

    begin
      client.put_object(
        bucket: BUCKET,
        key: key,
        body: processed,
        content_type: "image/webp"
      )
    rescue Aws::S3::Errors::ServiceError, Seahorse::Client::NetworkingError => e
      Rails.logger.error("[AvatarUploader] fail uploading to S3 for user #{creator_id}: #{e.class} #{e.message}")
      raise AvatarUploadError, "Could not upload the image"
    end

    "#{credentials[:uploads_url]}/#{key}"
  end
end
