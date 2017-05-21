class SearchesController < ApplicationController
  def index
    # Check if we have keywords and process the search
    search_params = params[:search] && params[:search][:keywords]
    if (search_params)
      @search = Search.new(search_params)
    end
  end
end
