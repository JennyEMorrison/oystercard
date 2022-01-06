require 'oystercard'

describe Oystercard do

  let(:entry_station){ double :station }
  let(:exit_station){ double :station }

  context 'oystercard topped up and touched in' do
    before do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in(entry_station)
    end
    it 'stores the starting station' do
      expect(subject.entry_station).to eq entry_station
    end

    it 'stores the exit station' do
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq exit_station
    end
  end

  it 'has a balance of zero' do
    expect(subject.balance).to eq (0)
  end
  
  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }
  end

  it 'can top up the balance' do
    expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
  end
  context 'testing balance limit' do
    before(:each) do
      @maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(@maximum_balance)
    end 
    it 'raises an error if the maximun balance is exceeded' do
      expect{ subject.top_up 1 }.to raise_error "maximum balance of #{@maximum_balance} exceeded"
    end
  end

  it 'is initially not in a journey' do
    expect(subject).not_to be_in_journey
  end

  context 'testing minimum balance' do
    before do
      minimum = Oystercard::MINIMUM_BALANCE
      subject.top_up(minimum)
      subject.touch_in(entry_station)
    end

    it 'can touch in' do
      expect(subject).to be_in_journey
    end
    
    describe '#touch_out' do
      it 'can touch out' do
        subject.touch_out(exit_station)
        expect(subject).not_to be_in_journey
        end
        let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
        it "stores a journey" do
          subject.touch_in(entry_station)
          subject.touch_out(exit_station)
          expect(subject.journey_history).to include journey
        end
      end
      
    

      it 'will deduct the correct fare at end of journey' do      
        expect { subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_BALANCE)
    end

    it "has an empty list of journey by default" do
      expect(subject.journey_history).to be_empty
    end
  end
  
  it 'will not touch in if below minimum amount' do
    expect{ subject.touch_in(entry_station) }.to raise_error 'unable to touch in, insufficient balance'
  end
end
