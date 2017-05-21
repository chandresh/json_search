require 'test_helper'

class SearchesTest < ActionController::TestCase
  test 'search#results should return correct records' do
    # Keyword search
    @search = Search.new('Java')
    assert_includes(@search.results.map { |row| row.name }, 'Java')
    assert_includes(@search.results.map { |row| row.name }, 'JavaScript')
    @search = Search.new('Scripting Microsoft')
    assert_includes(@search.results.map { |row| row.name }, 'JScript')
    assert_includes(@search.results.map { |row| row.name }, 'VBScript')
    assert_includes(@search.results.map { |row| row.name }, 'Windows PowerShell')
    # Absolute search
    @search = Search.new('Interpreted "Thomas Eugene"')
    assert_includes(@search.results.map { |row| row.name }, 'BASIC')
    refute_includes(@search.results.map { |row| row.name }, 'Haskell')
    # Negative search
    @search = Search.new('-Java')
    refute_includes(@search.results.map { |row| row.name }, 'Java')
    refute_includes(@search.results.map { |row| row.name }, 'JavaScript')

    @search = Search.new('john -array')
    assert_includes(@search.results.map { |row| row.name }, 'BASIC')
    assert_includes(@search.results.map { |row| row.name }, 'Haskell')
    assert_includes(@search.results.map { |row| row.name }, 'Lisp')
    assert_includes(@search.results.map { |row| row.name }, 'S-Lang')
    refute_includes(@search.results.map { |row| row.name }, 'Chapel')
    refute_includes(@search.results.map { |row| row.name }, 'Fortran')
    refute_includes(@search.results.map { |row| row.name }, 'S')
  end

  test 'results have correct relevance' do
    # relevance = frequency + (exact_matches * 20)

    @search = Search.new('Java')
    # There should be 2 results
    # Java should come first and JavaScript last
    # Java should have a score of 21 and JavaScript 1
    assert_equal(@search.results.count, 2)
    assert_equal(@search.results.first.name, 'Java')
    assert_equal(@search.results.first.relevance, 21)
    assert_equal(@search.results.last.name, 'JavaScript')
    assert_equal(@search.results.last.relevance, 1)
  end

end
