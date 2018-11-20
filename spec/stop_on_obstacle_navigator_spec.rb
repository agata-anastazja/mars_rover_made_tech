require 'stop_on_obstacle_navigator'
describe StopOnObstacleNavigator do
  it 'can execute all commands when sensors see nothing (example 1)' do
    rover = double(execute_command: {sensors: [], foo: :bar})

    moves = [:who_cares, :arbitrary]

    result = described_class.new(rover: rover).execute_commands(moves)

    expect(rover).to have_received(:execute_command).with(:who_cares).once
    expect(rover).to have_received(:execute_command).with(:arbitrary).once
    expect(result).to eq(sensors: [], foo: :bar)
  end

  it 'can execute all commands when sensors see nothing (example 2)' do
    rover = double(execute_command: {sensors: [], foo: :bar})
    allow(rover).to receive(:sensors).and_return([])
    moves = [:a_command, :that, :is]

    result = described_class.new(rover: rover).execute_commands(moves)

    expect(rover).to have_received(:execute_command).with(:a_command).once
    expect(rover).to have_received(:execute_command).with(:that).once
    expect(rover).to have_received(:execute_command).with(:is).once

    expect(result).to eq(sensors: [], foo: :bar)
  end

  it 'can execute all commands up to when the sensors detect an obstacle' do
    rover = double(:execute_command)
    first_return = {sensors: [], foo: :bar}
    second_return = {sensors: [:obstacle_detected], foo: :bar}
    third_return = {sensors: [], foo: :wrong}
    allow(rover).to receive(:execute_command).and_return(first_return, second_return, third_return)
    moves = [:a_command, :that, :is]

    result = described_class.new(rover: rover).execute_commands(moves)

    expect(rover).to have_received(:execute_command).with(:a_command).once
    expect(rover).to have_received(:execute_command).with(:that).once
    expect(rover).not_to have_received(:execute_command).with(:is)

    expect(result).to eq(sensors: [:obstacle_detected], foo: :bar)
  end
end
