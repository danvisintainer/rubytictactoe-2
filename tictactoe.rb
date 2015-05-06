require 'pry'

class TictactoeGame

  def initialize
    @board = []
    @x_is_human = true
    @o_is_human = true
    @current_turn = 'X'
  end

  def setup_board(n)
    n.times do |row|
      @board[row] = []
      n.times do |cell|
        @board[row][cell] = '-'
      end
    end

    print_board
  end

  def setup_game
    puts "Let's play Tic-Tac-Toe!"
    puts "Will X be a human? (y/n)"
    @x_is_human = false if gets.chomp == 'n'

    puts "Will O be a human? (y/n)"
    @o_is_human = false if gets.chomp == 'n'

    puts "How big do you want your board? (2-10)"
    setup_board(gets.chomp.to_i)
    decide_first_turn
  end

  def print_board
    board_size = @board.length

    print "  "
    board_size.times do |i|
      print " #{i + 1}  "
    end
    puts ""

    board_size.times do |row|
      print "#{(65 + row).chr} "
      board_size.times do |cell|
        output = " #{@board[row][cell]}"
        output += " |" unless (cell + 1) == board_size
        print output
      end
      
      print "\n  "
      
      board_size.times do |i|
        output = '---'
        output += '+' unless (i + 1) == board_size
        print output
      end unless (row + 1) == board_size
      
      puts ""
    end
  end

  def is_human?(player)
    if player == 'X'
      @x_is_human
    elsif player == 'O'
      @o_is_human
    end
  end

  def decide_first_turn
    [true, false].sample ? @current_turn = 'X' : @current_turn = 'O'
    puts "I've thought about this, and I think #{@current_turn} should go first!"
  end

  def start_turn
    is_human?(@current_turn) ? human_turn : computer_turn
  end

  def next_turn
    @current_turn == 'X' ? @current_turn = 'Y' : @current_turn = 'X'
  end

  def human_turn
    puts "It's your turn, #{@current_turn}. Which space do you want?"
  end

  def computer_turn
    puts "It's #{@current_turn}'s turn - that's me! Hmm..."
  end

  def go
    setup_game
    start_turn
    next_turn
  end

end

TictactoeGame.new.go