class GravatarClient
  BASE_URL = "https://api.gravatar.com/v3"

  def initialize
    @http = Faraday.new(url: BASE_URL) do |f|
      f.headers["Authorization"] =
        "Bearer #{Rails.application.credentials.dig(:gravatar, :api_key)}"

      f.headers["Content-Type"] = "application/json"
    end
  end

  def profile(email)
    response = @http.get("profiles/#{hash_email(email)}")

    return nil unless response.success?

    JSON.parse(response.body)
  end

  private
    def hash_email(email)
      Digest::SHA256.hexdigest(email.strip.downcase)
    end
end
