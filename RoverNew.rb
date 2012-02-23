class Position
  attr_reader :xpos, :ypos
  def initialize(x,y)
    @xpos = x
    @ypos = y
  end

  def change(posx,posy) 
    @xpos = posx
    @ypos = posy
    yield
  end
end

class Grid
  def initialize(x,y)
    @@maxx = x
    @@maxy = y
  end

  def outside?(posx,posy) 
    (((posx > @@maxx) or (posy > @@maxy)) or ((posx < 0) or (posy <0)))
  end
end

class Direction
  attr_reader :dir, :NEW_DIRECTION_MAPPINGS
  attr_writer :dir
  def initialize
    @dir = :N
    @@NEW_DIRECTION_MAPPINGS = { 
      [:N, :L] => :W,
      [:N, :R] => :E,
      [:W, :L] => :S,
      [:W, :R] => :N,
      [:S, :L] => :E,
      [:S, :R] => :W,
      [:E, :L] => :N,
      [:E, :R] => :S
      }
  end

  def map_new(side)
    @@NEW_DIRECTION_MAPPINGS[[@dir,side]]
  end
end

class Rover 
  def initialize(posx,posy) 
    @orientation = Direction.new
    puts "Success! Rover deployed at (#{posx},#{posy})."
    @pos = Position.new(posx,posy)
  end	

  def Rover.deploy_new(theGrid,init_position = {:coordinates => [0,0]})

    posx = init_position[:coordinates][0]
    posy = init_position[:coordinates][1]

    if theGrid.outside?(posx, posy) 
      puts "Error! The position is out of the grid..."
    else 
      Rover.new(posx, posy)
    end

  end

  def turn_left
    @orientation.dir = @orientation.map_new(:L)
    puts "Rover turned to face #{@orientation.dir}."
  end

  def turn_right
    @orientation.dir = @orientation.map_new(:R)
    puts "Rover turned to face #{@orientation.dir}."
  end

  def step(theGrid) 
    newX = @pos.xpos
    newY = @pos.ypos
    case @orientation.dir
    when :N
      newY = @pos.ypos + 1
    when :W
      newX = @pos.xpos - 1
    when :S
      newY = @pos.ypos - 1
    when :E
      newX = @pos.xpos + 1
    end
    if theGrid.outside?(newX,newY)
      puts "Error! The destination is out of the grid..."
    else
      @pos.change(newX, newY) { puts "Rover stepped to (#{newX}, #{newY})" }
    end
  end

  def move(theGrid, d_input)
    case d_input
    when :R
      turn_right
    when :L
      turn_left
    end
    step(theGrid)
  end

  def current_position
    puts "The current position: " + [@pos.xpos, @pos.ypos].to_s
  end
end

grid = Grid.new(5,5)
rover1 = Rover.deploy_new(grid)
rover1.move(grid,:R)
rover1.move(grid,:A)
rover1.move(grid,:L)
rover1.move(grid,:A)
rover1.move(grid,:R)
rover1.move(grid,:A)
rover1.current_position
rover2 = Rover.deploy_new(grid, :coordinates => [2,1])
rover3 = Rover.deploy_new(grid)