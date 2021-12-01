class FileDoesNotExistException < Exception
    public
    def initialize(filename)
        @message = "File '#{filename}' does not exist"
    end

    attr_reader :message
end

class Sonar
    private
    
    def initialize(depth_list)
        @depth_list = depth_list
        calculate_sliding_window
    end
    
    class << self
        private :new
    end
    
    def calculate_sliding_window
        @window_sums = []
        n_slides = @depth_list.length() - 2
        (0...n_slides).each do |i| 
            @window_sums.push(
                @depth_list[i] + @depth_list[i+1] + @depth_list[i+2]
            )
        end
    end
    
    def count_increases(array)
        increases = 0
        array.each_with_index do |element, index|
            unless index == 0
                increases += 1 if element > array[index-1]
            end
        end
        return increases
    end

    
    public
    def self.from_file(filename)

        unless File.exists?(filename)
            raise FileDoesNotExistException.new(filename)
        end

        lines = File.read(filename).split.map{ |n| n.to_i }

        return self.new(lines)
    end

    def scan
        return count_increases(@depth_list)
    end

    def scan_with_window
        return count_increases(@window_sums)
    end
end


if __FILE__ == $0

    puts "File to read: "
    filename = gets.chomp

    begin
        sonar = Sonar.from_file(filename)
    rescue FileDoesNotExistException => error
        puts error.message
        exit
    end

    puts "Silver star: #{sonar.scan}"
    puts "Gold star: #{sonar.scan_with_window}"
end