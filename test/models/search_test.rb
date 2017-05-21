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

end
