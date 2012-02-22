class Grid
	@@position = Hash.new(0); #Class variable for denoting the grid.
	def initialize(x,y)
		@@maxx = x
		@@maxy = y
	end

	def changeStat(posx,posy) #Changes any the occupancy of a point in the grid from true to false and vice versa.
		if @@position.key? [posx,posy]
			@@position.delete([posx,posy])
		else
			@@position[[posx,posy]] = true
		end
	end

	def isOccupied(posx,posy) #Returns true if the point in the grid is occupied.
		@@position.key? [posx,posy]
	end

	def isOutofGrid(posx,posy) #Returns true if the point is not in the grid.
		(((posx > @@maxx) or (posy > @@maxy)) or ((posx < 0) or (posy <0)))
	end

	def Grid.listAllRovers() #Lists all the positions of the grid that are currently occupied.
		print "Rovers are present at -"
		@@position.each_key do
			|key| print "#{key} "
		end
	end
end


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
	def initialize(theGrid,posx,posy) #Places a rover on the grid.
		theGrid.changeStat(posx,posy)
		@dir = :N
		puts "Success! Rover deployed at (#{posx},#{posy})"
	end	

	def Rover.deployNewRover(theGrid,posx,posy)
		if (not theGrid.isOccupied(posx,posy)) and (not theGrid.isOutofGrid(posx,posy))
			new(theGrid,posx,posy) 
		else 
			puts "Error! The position is either occupied or it is out of the grid..."
		end
	end

	def getDirection(posx,posy,d)
		if d == :M
			newDir = @dir
		else
			newDir = @@NewDirectionMappings[[@dir, d]]
		end
		return newDir
	end

	def moveRover(theGrid,posx,posy,d) #Calculates the new position of the rover given the new direction and moves it there.
		newX = posx
		newY = posy
		if not theGrid.isOccupied(posx,posy)
			puts "Error! There is no rover at (#{posx},#{posy})..."
		else
			newDir = getDirection(posx,posy,d)
			case newDir
			when :N
				newY = posy + 1
			when :W
				newX = posx - 1
			when :S
				newY = posy - 1
			when :E
				newX = posx + 1
			end
			if (theGrid.isOccupied(newX,newY) or theGrid.isOutofGrid(newX,newY))
				puts "Error! Either a rover already occupies the space or the point is out of the scope.."
			else
				theGrid.changeStat(posx,posy)
				theGrid.changeStat(newX,newY)
				@dir = newDir
				puts "Success! New position is (#{newX},#{newY})"
			end
		end
	end
end


grid = Grid.new(5,5)
rover1 = Rover.deployNewRover(grid,0,0)
rover1.moveRover(grid,0,0,:R)
rover1.moveRover(grid,1,0,:M)
rover1.moveRover(grid,2,0,:L)
rover1.moveRover(grid,2,1,:M)
rover1.moveRover(grid,2,2,:R)
rover1.moveRover(grid,3,2,:M)
rover2 = Rover.deployNewRover(grid,1,3)
rover3 = Rover.deployNewRover(grid,5,5)
Grid.listAllRovers()
