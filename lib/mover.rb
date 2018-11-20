class Mover
  def initialize(hardware_api:)
    @hardware_api = hardware_api
  end

  def make_move(move)
    @obstacle_detected = false
    turned = 0

    if move == :forward
      displacement = @hardware_api.move_forward
      check_obstacles(displacement)
    elsif move == :backward
      displacement = @hardware_api.move_backward
      check_obstacles(displacement)
    elsif move == :turn_left
      @hardware_api.turn_left
      displacement = 0
      turned = -1
    else
      @hardware_api.turn_right
      displacement = 0
      turned = 1
    end

    [displacement, turned]
  end

  def check_obstacles(displacement)
    @obstacle_detected = true if displacement == 0
  end

  def obstacle_detected?
    @obstacle_detected
  end
end
