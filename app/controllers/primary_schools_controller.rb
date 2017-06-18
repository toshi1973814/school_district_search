class PrimarySchoolsController < ApplicationController

  if ENV["PRIMARY_SCHOOL_SEARCH_AUTH_ID"] && ENV["PRIMARY_SCHOOL_SEARCH_AUTH_PW"]
    http_basic_authenticate_with name: ENV["PRIMARY_SCHOOL_SEARCH_AUTH_ID"], password: ENV["PRIMARY_SCHOOL_SEARCH_AUTH_PW"]
  end

  def search
    if params[:lat].present? && params[:lng].present?
      @results = PrimarySchool.search( lat: params[:lat], lng: params[:lng] )
      @place = Place.new(latitude: params[:lat], longitude: params[:lng])
    else
      @place = Place.first
    end

    @hash = Gmaps4rails.build_markers(@place) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      marker.infowindow place.name
    end

  end

end
