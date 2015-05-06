require 'pry'

class TictactoeGame

  def initialize
    @board = []
  end

  def initialize_board(n)
    n.times do |row|
      @board[row] = []
      n.times do |column|
        @board[row][column] = '-'
      end
    end

    puts @board.inspect
  end

  def go
    puts "Let's play Tic-Tac-Toe!"
    puts "How big do you want your board?"
    initialize_board(gets.chomp.to_i)
  end

end

TictactoeGame.new.go