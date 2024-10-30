# app/controllers/bands_controller.rb
class BandsController < ApplicationController
  require 'faraday'

  # Action to fetch bands based on a location
  def search
    city = params[:city]
    if city.blank?
      render json: { error: "City parameter is required" }, status: :bad_request
      return
    end

    # Make a request to MusicBrainz API
    response = Faraday.get("https://musicbrainz.org/ws/2/artist/", {
      query: "area:#{city} AND begin:[#{Time.now.year - 10} TO *]",
      fmt: "json",
      limit: 50
    })

    if response.success?
      bands = JSON.parse(response.body)["artists"]
      render json: bands, status: :ok
    else
      render json: { error: "Failed to fetch bands" }, status: :unprocessable_entity
    end
  end

  # Action to get city from IP-based geolocation
  def location
    response = Faraday.get("https://get.geojs.io/v1/ip/geo.json")
    if response.success?
      location_data = JSON.parse(response.body)
      render json: { city: location_data["city"] }, status: :ok
    else
      render json: { error: "Failed to fetch location" }, status: :unprocessable_entity
    end
  end
end
