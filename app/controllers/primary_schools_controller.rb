class PrimarySchoolsController < ApplicationController

  def search
    if params[:lat].present? && params[:lng].present?
      @results = PrimarySchool.search( lat: params[:lat], lng: params[:lng] )
    end

    @places = Place.first
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      marker.infowindow place.name
    end

  end

end
