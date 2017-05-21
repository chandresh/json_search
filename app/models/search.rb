class Search
  SPECIAL_CHARS = %w(" -)
  attr_accessor :keywords, :exact_match

  def initialize(keywords)
    # Original keywords entered by user
    @keywords           = keywords
    # Copy of keywords lowercased for further processing
    @processed_keywords = keywords
                              .downcase
                              .gsub(/(?=\S)"/, ' "') # Add space before quote that are directly after a character
                              .gsub(/"(?=\S)/, '" ') # Add space after quote that are directly before a character

    @tokens          = []
    @negative_tokens = []

    # call tokenize method to populate @tokens & @negative_tokens
    tokenize
  end

  def results
    match_tokens(remove_negative_tokens(data))
  end

  private

  def tokenize
    @tokens = @processed_keywords
                  .scan(/(?:[^ \t\r\n\f"]|"[^"]*")+/) # Non-whitespace characters or sentences within quotes
                  .map { |token| token.gsub('"', '').strip } # Remove quotes and extra space from token beginning & end
                  .reject(&:blank?) # remove any tokens with only whitespace

    @negative_tokens = @tokens.select { |token| token.start_with?('-') }
                           .map { |token| token.gsub('-', '') }
    @tokens          = @tokens.reject { |token| token.start_with?('-') }

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