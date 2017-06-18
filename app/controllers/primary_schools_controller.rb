class PrimarySchoolsController < ApplicationController

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
