class JpCitiesController < ApplicationController

  def search
    if params[:lat].present? && params[:lng].present?
      @results = JpCity.search( lat: params[:lat], lng: params[:lng] )
    end
  end

end
