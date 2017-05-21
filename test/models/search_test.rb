require 'test_helper'

class SearchesTest < ActionController::TestCase
  test "search#results should return correct records" do
    # Keyword search
    @search = Search.new('Java')
    assert_includes(@search.results.map{|row| row.name}, "Java")
    assert_includes(@search.results.map{|row| row.name}, "JavaScript")
    # Absolute search
    @search = Search.new('"Java"')
    assert_includes(@search.results.map{|row| row.name}, "Java")
    refute_includes(@search.results.map{|row| row.name}, "JavaScript")
    # Negative search
    @search = Search.new('-Java')
    refute_includes(@search.results.map{|row| row.name}, "Java")
    refute_includes(@search.results.map{|row| row.name}, "JavaScript")
  end

end
