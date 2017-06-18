class PrimarySchoolsController < ApplicationController

  def search
    if params[:lat].present? && params[:lng].present?
      @results = PrimarySchool.search( lat: params[:lat], lng: params[:lng] )
    end
  end

end
