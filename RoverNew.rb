class Position
	attr_reader :xpos, :ypos
	def initialize(x,y)
		@xpos = x
		@ypos = y
	end

	def changePosition(posx,posy) #Changes any the occupancy of a point in the grid from true to false and vice versa.
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

	def isOutofGrid(posx,posy) #Returns true if the point is not in the grid.
		(((posx > @@maxx) or (posy > @@maxy)) or ((posx < 0) or (posy <0)))
	end
end

#Need to rewrite function to display all positions of rovers...

class Rover 
	@@NewDirectionMappings = { #This is a class variable containing the new direction of the rover giving the current direction and the turn.
			[:N, :L] => :W,
			[:N, :R] => :E,
			[:W, :L] => :S,
			[:W, :R] => :N,
			[:S, :L] => :E,
			[:S, :R] => :W,
			[:E, :L] => :N,
			[:E, :R] => :S
			}
	def initialize(posx,posy) #Places a rover on the grid.
		@dir = :N
		puts "Success! Rover deployed at (#{posx},#{posy})"
		@pos = Position.new(posx,posy)
	end	

	def Rover.deployNewRover(theGrid,posx,posy)
		if not theGrid.isOutofGrid(posx,posy)
			new(posx,posy) 
		else 
			puts "Error! The position is out of the grid..."
		end
	end

	def getDirection(d)
		if d == :M
			newDir = @dir
		else
			newDir = @@NewDirectionMappings[[@dir, d]]
		end
		return newDir
	end

	def moveRover(theGrid,d) #Calculates the new position of the rover given the new direction and moves it there.
		newDir = getDirection(d)
		newX = @pos.xpos
		newY = @pos.ypos
		case newDir
		when :N
			newY = @pos.ypos + 1
		when :W
			newX = @pos.xpos - 1
		when :S
			newY = @pos.ypos - 1
		when :E
			newX = @pos.xpos + 1
		end
		if theGrid.isOutofGrid(newX,newY)
			puts "Error! The destination is out of the grid..."
		else
			@pos.changePosition(newX, newY) { puts "Rover moved to (#{newX}, #{newY})" }
			@dir = newDir
		end
	end
end


grid = Grid.new(5,5)
rover1 = Rover.deployNewRover(grid,0,0)
rover1.moveRover(grid,:R)
rover1.moveRover(grid,:M)
rover1.moveRover(grid,:L)
rover1.moveRover(grid,:M)
rover1.moveRover(grid,:R)
rover1.moveRover(grid,:M)
rover2 = Rover.deployNewRover(grid,1,3)
rover3 = Rover.deployNewRover(grid,5,5)
