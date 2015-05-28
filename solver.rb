class Solver

  NUMS = [1,2,3,4,5,6,7,8,9]
  BOX_COORDINATES = [[0,1,2],[3,4,5],[6,7,8]]

  def initialize(sudoku)
    @grid = sudoku.scan(/\d{9}/).map { |row| row.split("").map { |cell| cell.to_i } }
    @row_coordinates = []
    @column_coordinates = []
    @possibilities = []
  end

  def solve!
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        check_cell(row_index, cell_index) unless row[cell_index] != 0
      end
    end
  end

  def check_cell(r,c)
    @possibilities = []
    NUMS.each do |num|
      if check_box(r, c, num) && check_row(r, c, num) && check_column(r, c, num)
          @possibilities << num
      end
    end
    insert_num(r,c,num = @possibilities[0]) if @possibilities.length == 1
  end

  def check_box(r,c,num)
    get_box_coordinates(r,c)
    box_contains = []
    @row_coordinates.each do |row|
      @column_coordinates.each do |column|
        box_contains << @grid[row][column]
      end
    end
    true unless box_contains.include?(num)
  end

  def check_row(r,c,num)
    true unless @grid[r].include?(num)
  end

  def check_column(r,c,num)
    transposed_grid = @grid.transpose
    true unless transposed_grid[c].include?(num)
  end

  def get_box_coordinates(r,c)
    row_coordinates = BOX_COORDINATES.select { |box| box.include?(r)}
    column_coordinates = BOX_COORDINATES.select { |box| box.include?(c)}
    @row_coordinates = row_coordinates[0].map { |coordinate| coordinate.to_i }
    @column_coordinates = column_coordinates[0].map { |coordinate| coordinate.to_i }
  end

  def insert_num(r,c,num)
    @grid[r][c] = num
  end

  def finished?
    x = @grid.map { |row| row.include?(0)}
    x.all? { |y| y == false }
  end

  def board
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        if cell_index == 3 || cell_index == 7
          row.insert(cell_index, "|")
        end
      end
      row.insert(0, "|") && row.insert(-1, "|")
    end
    new_grid = @grid.transpose
    new_grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        if cell_index == 3 || cell_index == 7
          row.insert(cell_index, "–")
        end
      end
      row.insert(0, "–") && row.insert(-1, "–")
    end
    puts new_grid.transpose.map { |row| row.join(" ") }
  end

end

board_string = File.readlines('unsolved.txt')#.first.chomp

sudoku = 0
until sudoku == board_string.length + 1
  game = Solver.new(board_string[sudoku])

  game.solve! until game.finished?

  sudoku += 1

  puts "Sudoku #{sudoku}"
  puts game.board

end