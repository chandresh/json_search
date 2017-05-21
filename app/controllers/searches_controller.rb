class SearchesController < ApplicationController
  def index
    # Check if we have keywords and process the search
    search_params = params[:search] && params[:search][:keywords]
    if (search_params)
      @search         = Search.new(search_params)
      @search_results = @search.results.sort_by(&:relevance).reverse
    end
  end
end
