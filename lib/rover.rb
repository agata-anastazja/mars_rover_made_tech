class Rover
  DIRECTIONS = ['N', 'E', 'S', 'W'].freeze

  def initialize(starting_position:, direction:, mover:)
    @mover = mover
    @direction = direction
    @current_position = starting_position
  end

  def execute_command(move)
    displacement, turned = @mover.make_move(move)
    new_position(displacement)

    {
      sensors: @mover.obstacle_detected? ? [:obstacle_detected] : [],
      x: @current_position[0],
      y: @current_position[1],
      direction: new_direction(turned)
    }
  end

  def new_position(displacement)
    if @direction == 'E'
      @current_position[0] += displacement
    elsif @direction == 'W'
      @current_position[0] -= displacement
    elsif @direction == 'S'
      @current_position[1] -= displacement
    else
      @current_position[1] += displacement
    end
  end

  def new_direction(turned)
    index = DIRECTIONS.index(@direction)
    DIRECTIONS[index + turned]
  end
end
