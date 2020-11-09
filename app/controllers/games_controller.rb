require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    letters = ('A'..'Z').to_a
    @selection = []
    10.times do
      @selection << letters[Random.new.rand(letters.length)]
    end
  end

  def score
    @word = params[:word].upcase
    @selection = params[:selection]
    @result = ''

    @word.split('').each do |letter|
      @grid_word = @selection.split(' ').include? letter
    end

    @win = @grid_word && english_word?(@word)

    @result = if @grid_word == false
                "Sorry, #{@word} is not made from grid!"
              elsif english_word?(@word) == false
                "Sorry, #{@word} is not an english word!"
              elsif @win == true
                "Congratulation! Your #{@word} is english word and it is made from grid!"
              end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end
end
