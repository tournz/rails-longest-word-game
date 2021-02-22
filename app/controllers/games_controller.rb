require 'open-uri'
require 'json'
require 'time'

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  charset = ('A'..'Z').to_a
  grid = []
  grid_size.times do
    grid << charset.sample
  end
  grid
end

def run_game(attempt, grid)
  result_hash = {}
  words = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
  flick = 0
  attempt_array = attempt.scan(/\w/)
  attempt_array.each { |letter| letter.upcase! }
  attempt_array.each { |letter| flick = 1 if attempt_array.count(letter) > grid.count(letter) }
  if words["found"] == true && flick.zero?
    result_hash[:score] = 50 + 5 * attempt.length.to_i
    result_hash[:message] = "Well done"
  else
    result_hash[:score] = 0
    result_hash[:message] = words["found"] == false ? 'Not an English word' : 'Not in the grid'
  end
  result_hash
end

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @results = run_game(params[:word], params[:letters])
    @word = params[:word]
    @letters = params[:letters]
  end
end
