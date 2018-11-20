require 'rover'
require 'mover'

describe "Navigator " do
  def expect_sensors_to_detect_nothing(result)
    expect(result[:sensors]).to eq([])
  end

  def expect_sensors_to_detect_an_obstacle(result)
    expect(result[:sensors]).to eq([:obstacle_detected])
  end

  def expect_position_to_be(expected, result)
    expect(result).to include(expected)
  end

  def start_at_origin_with_direction(direction, hardware_api)
    Rover.new(
      starting_position: [0,0],
      direction: direction,
      mover: Mover.new(hardware_api: hardware_api)
    )
  end

  it "can hit an obstacle and report position and sensor information" do
    hardware_api = double(move_forward: 0)
    rover = start_at_origin_with_direction('N', hardware_api)

    result = rover.execute_command(:forward)

    expect_sensors_to_detect_an_obstacle(result)
    expect(result).to include(x: 0, y: 0)
  end

  it "can move forward north" do
    hardware_api = double(move_forward: 1)
    rover = start_at_origin_with_direction('N', hardware_api)

    result = rover.execute_command(:forward)

    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: 0, y: 1, direction: "N"}, result)
  end

  it "can move forward south" do
    hardware_api = double(move_forward: 1)
    rover = start_at_origin_with_direction('S', hardware_api)

    result = rover.execute_command(:forward)

    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: 0, y: -1, direction: "S"}, result)
  end

  it "can move forward east" do
    hardware_api = double(move_forward: 1)
    rover = start_at_origin_with_direction('E', hardware_api)

    result = rover.execute_command(:forward)

    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: 1, y: 0, direction: "E"}, result)
  end

  it "can move backward when facing north" do
    hardware_api = double(move_backward: -1)
    rover = start_at_origin_with_direction('N', hardware_api)

    result = rover.execute_command(:backward)

    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: 0, y: -1, direction: "N"}, result)
  end

  it "can turn left when facing north" do
    hardware_api = double(turn_left: nil)
    rover = start_at_origin_with_direction('N', hardware_api)

    result = rover.execute_command(:turn_left)

    expect(hardware_api).to have_received(:turn_left)
    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: 0, y: 0, direction: "W"}, result)
  end

  it "can turn right when facing north" do
    hardware_api = double(turn_right: nil)
    rover = start_at_origin_with_direction('N', hardware_api)

    result = rover.execute_command(:turn_right)

    expect(hardware_api).to have_received(:turn_right)
    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: 0, y: 0, direction: "E"}, result)
  end

  it "can turn left when facing east" do
    hardware_api = double(turn_left: nil)
    rover = start_at_origin_with_direction('E', hardware_api)

    result = rover.execute_command(:turn_left)

    expect(hardware_api).to have_received(:turn_left)
    expect_position_to_be({x: 0, y: 0, direction: "N"}, result)
  end

  it "can move forward north twice" do
    hardware_api = double(move_forward: 1)
    rover = start_at_origin_with_direction('N', hardware_api)

    result = rover.execute_command(:forward)
    result = rover.execute_command(:forward)

    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: 0, y: 2, direction: "N"}, result)
  end

  it "can move forward west twice" do
    hardware_api = double(move_forward: 1)
    rover = start_at_origin_with_direction('W', hardware_api)

    result = rover.execute_command(:forward)
    result = rover.execute_command(:forward)

    expect_sensors_to_detect_nothing(result)
    expect_position_to_be({x: -2, y: 0, direction: "W"}, result)
  end
end
