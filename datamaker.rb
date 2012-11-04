class Data::Maker
end

#################################################################
class Data::Maker::Field
	def initialize
	end
end

#################################################################
class Data::Maker::Field::Set < Data::Maker::Field
	def initialize(set)
		@set = set
	end
	def generate_value
		return @set[rand @set.size]
	end
end

#################################################################
class Data::Maker::Field::Format

	def initialize(format='')
		@format = format
		@lower = ('a'..'z').to_a
		@upper = @lower.map{|i| i.upcase}
		@letters = [@lower, @upper].flatten
		@digits = (0..9).to_a
		@chars = [@letters, @digits ].flatten.map{|i| i.to_s}
		@hex = (0..255).to_a.map{|i| i.to_s(16).rjust(2,'0')}
		@firstnames = File.new('datafiles/firstnames.txt').map{|i| i.sub!(/\n/, '')}
		@lastnames = File.new('datafiles/lastnames.txt').map{|i| i.sub!(/\n/, '')}
	end

	attr_accessor :format

	def random_digit;     return random_from_list( @digits ); end
	def random_letter;    return random_from_list( @letters); end
	def random_character; return random_from_list( @chars  ); end
	def random_upper;     return random_from_list( @upper  ); end
	def random_hex;       return random_from_list( @hex  ); end

	def random_from_list(list)
		return list[rand list.size]
	end

	def generate_value
		out = self.format.gsub(/\\d/) { |i| random_digit.to_s }
		out.gsub!(/\\l/) { |i| random_letter            }
		out.gsub!(/\\w/) { |i| random_character         }
		out.gsub!(/\\W/) { |i| random_character.upcase  }
		out.gsub!(/\\L/) { |i| random_upper             }
		out.gsub!(/\\x/) { |i| random_hex               }
		out.gsub!(/\\X/) { |i| random_hex.upcase        }
		return out
	end

end

#################################################################
class Data::Maker::Field::Str < Data::Maker::Field

	def initialize(i)
		@i = i.to_i
		@lower = ('a'..'z').to_a
		@upper = @lower.map{|i| i.upcase}
		@letters = [@lower, @upper].flatten
		@digits = (0..9).to_a
		@chars = [@letters, @digits ].flatten.map{|i| i.to_s}
	end

	def generate_value
		out = String.new
		(1..@i).to_a.each {
			|j|
			out += @chars[ rand @chars.size ].to_s
		}
		return out
	end
end

#################################################################
class Data::Maker::Field::Phone < Data::Maker::Field
	def initialize(delimiter='-')
		@delimiter = delimiter
	end
	def generate_value
		area_code = self.area_code
		exchange = self.area_code # same rules as area code
		extension = self.extension
		return [area_code, exchange, extension].join(@delimiter)
	end
	def area_code
		first = Data::Maker::Field::Set.new( (2..9).to_a ).generate_value
		second = Data::Maker::Field::Set.new( (0..9).to_a ).generate_value
		third = Data::Maker::Field::Set.new( (0..9).to_a ).generate_value
		return [first,second,third].join('')
	end
	def extension
		out = Array.new
		(1..4).to_a.each {
			out.push(Data::Maker::Field::Set.new( (0..9).to_a ).generate_value)
		}
		return out.join('')
	end
end
#################################################################
class Data::Maker::Field::Join < Data::Maker::Field
	def initialize(fields=[], delimiter=' ')
		@fields = fields
		@delimiter = delimiter
	end

	def generate_value
		return @fields.map {
			|i|
			i.generate_value
		}.join(@delimiter)
	end
end

#################################################################
class Data::Maker::Field::TextFile < Data::Maker::Field

	def initialize(filename)
		@filename = filename
		@lines = File.new(filename).readlines.map{ |i| i.sub!(/\n$/, '') }
		@line_count = @lines.size
	end

	attr_accessor :filename

	def generate_value
		return @lines[rand @line_count]
	end

end

#################################################################
class Data::Maker::Field::SSN < Data::Maker::Field::Format
	def initialize
		super('\d\d\d-\d\d-\d\d\d\d')
	end
end

#################################################################
class Data::Maker::Field::Company < Data::Maker::Field::TextFile
	def initialize
		super('datafiles/companies.txt')
	end
end

#################################################################
class Data::Maker::Field::FirstName < Data::Maker::Field::TextFile
	def initialize
		super('datafiles/firstnames.txt')
	end
end

#################################################################
class Data::Maker::Field::LastName < Data::Maker::Field::TextFile
	def initialize
		super('datafiles/lastnames.txt')
	end
end

#################################################################
class Data::Maker::Field::MiddleName
	def initialize(*args)
		@dot = false
		if (arg = args.shift)
			@dot = arg[:dot]
		end
		@letters = ('A'..'Z').to_a.reject{|i| i =~ /^Q|X$/}
	end
	def generate_value
		return @letters[rand @letters.size] + (@dot ? '.' : '')
	end
end
