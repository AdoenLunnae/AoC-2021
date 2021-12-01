require_relative "day1"
require "rspec/mocks"

describe FileDoesNotExistException do
    it "contains the filename in the message" do
        
        fake_filename = "test"

        e = FileDoesNotExistException.new(fake_filename)
        expect(e.message).to include(fake_filename)
    end
end


describe Sonar do
    before(:all) do
        @filename = "fake file"
        @data = "123\n456\n789\n"
        @parsed_data = @data.split.map {|n| n.to_i}
    end

    describe "Factory" do
        it "can construct from a file" do
            allow(Sonar).to receive(:new).and_call_original
            allow(File).to receive(:read).and_return(@data)
            allow(File).to receive(:exists?).and_return(true)
            sonar = Sonar.from_file(@filename)

            expect(Sonar).to have_received(:new).with(@parsed_data)
            expect(sonar).to be_instance_of(Sonar)
            expect(sonar.instance_variable_get(:@depth_list)).to eq(@parsed_data)

        end

        it "raises an exception if the file does not exist" do
            allow(File).to receive(:exists?).and_return(false)
            allow(FileDoesNotExistException).to receive(:new).and_call_original

            expect{ Sonar.from_file(@filename) }.to raise_error(FileDoesNotExistException)
            expect(FileDoesNotExistException).to have_received(:new).with(@filename)
        end
    end

    describe "Scan" do
        before(:all) do
            @sonar = Sonar.send(:new, @parsed_data)
        end

        it "calls the increase counter method" do
            allow_any_instance_of(Sonar).to receive(:count_increases).and_return({})
            @sonar.scan
            expect(@sonar).to have_received(:count_increases)
        end

        it "calculates the number of increases" do
            expect(@sonar.scan).to eq(2)
        end
    end

    describe "Scan with sliding window" do
        before(:all) do
            @long_data = "1\n3\n1\n2\n4\n3\n"
            # windows:
            # 1 3 1         5
            #   3 1 2       6
            #     1 2 4     7
            #       2 4 3   9
            @sonar = Sonar.send(:new, @long_data)
        end

        it "calls the increase counter method" do
            allow_any_instance_of(Sonar).to receive(:count_increases).and_return({})
            @sonar.scan_with_window
            expect(@sonar).to have_received(:count_increases)
        end

        it "calculates the number of increases" do
            expect(@sonar.scan_with_window).to eq(4)
        end
    end
end