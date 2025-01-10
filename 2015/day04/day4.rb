require 'digest'

input_file = ARGV[0]
md5 = Digest::MD5.new
File.open(input_file, "r") do |fh|
    fh.each_line do |prefix|
        part1 = nil
        part2 = nil
        md5.reset
        prefix.chomp!
        number = 1
        while not md5.hexdigest.start_with?('000000') 
            if md5.hexdigest.start_with?('00000') and part1.nil? then
                part1 = number - 1
            end
            md5.reset
            md5 << "#{prefix}#{number}"
            number += 1
        end
        puts part1
        puts number - 1
    end
end
