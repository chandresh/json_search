class Search

  attr_accessor :keywords, :exact_match

  def initialize(keywords)
    # Original keywords entered by user
    @keywords           = keywords
    # Copy of keywords lowercased for further processing
    @processed_keywords = keywords.downcase

    @tokens             = @processed_keywords.split
    @negative_tokens    = @tokens.select { |token| token.start_with?('-') }.map { |token| token[1..-1] }
    @tokens             = @tokens.reject { |token| token.start_with?('-') }
    # The keywords string starts and ends with "
    @exact_match        = /^".+"$/.match(keywords)
    if @exact_match
      # if it's an exact match, lets remove " from begineing & end
      @processed_keywords = @processed_keywords[1..-2]
    end
  end

  def results
    if @exact_match
      # if it's an exact match we will match it exactly with name, type and designed_by
      exact_search(data)
    else
      match_tokens(remove_negative_tokens(data))
    end

  end

  private

  def exact_search(data)
    data.select do |row|
      row.name.downcase == @processed_keywords || row.type.downcase == @processed_keywords || row.designed_by.downcase == @processed_keywords
    end
  end

  # This method takes in data in an array and returns an array containing all results with tokens
  def match_tokens(data)
    @tokens.each do |token|
      data = data.select do |row|
        row.name.downcase.include?(token) || row.type.downcase.include?(token) || row.designed_by.downcase.include?(token)
      end
    end
    data
  end

  # This method takes in data in an array and returns an array removing all results containing negative tokens
  def remove_negative_tokens(data)
    @negative_tokens.each do |negative_token|
      data = data.reject do |row|
        row.name.downcase.include?(negative_token) || row.type.downcase.include?(negative_token) || row.designed_by.downcase.include?(negative_token)
      end
    end
    data
  end

  def data
    # APP_DATA is loaded via an initializer from db/data.json
    # The initializer code is at: config/initializers/load_data.rb
    APP_DATA.map do |row|
      Result.new(name: row['Name'], type: row['Type'], designed_by: row['Designed by'])
    end
  end

  class Result
    attr_reader :name, :type, :designed_by, :relevance

    def initialize(name:, type:, designed_by:)
      @name        = name
      @type        = type
      @designed_by = designed_by
      @relevance   = 0
    end
  end

end