require 'station'

describe Station do
  subject {described_class.new(name: "Haymarket", zone: 1)}
  describe '#initialize' do
    it 'knows its name' do                      
      expect(subject).to respond_to(:name)             
    end                                                   

    it 'knows its zone' do                                                     
      expect(subject).to respond_to(:zone)                                
    end
  end
end
