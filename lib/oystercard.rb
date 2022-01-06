class Oystercard
  
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  attr_reader :balance, :entry_station, :exit_station, :journey_history

  def initialize
    @balance = 0
    @journey_history = []
  end
  
  def top_up(amount)
    fail "maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !!@entry_station
  end

  def touch_in(station)
    fail 'unable to touch in, insufficient balance' if @balance < MINIMUM_BALANCE
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_BALANCE)
    @exit_station = station
    @journey_history << { entry_station: @entry_station, exit_station: exit_station }
    @entry_station = nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end