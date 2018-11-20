class StopOnObstacleNavigator
  def initialize(rover:)
    @rover = rover
  end

  def execute_commands(moves)
    result = {}
    moves.each do |move|
      result = @rover.execute_command(move)
      if result[:sensors] != []
        break
      end
    end
    result
  end
end
