require 'pp'
require './datamaker.rb'

count = ARGV.shift.to_i

firstname =	Data::Maker::Field::FirstName.new
middlename = Data::Maker::Field::MiddleName.new
lastname = Data::Maker::Field::LastName.new

fullname = Data::Maker::Field::Join.new([
	firstname,
	middlename,
	lastname
])

company =	Data::Maker::Field::Company.new

ssn = Data::Maker::Field::SSN.new
phone = Data::Maker::Field::Format.new('(\d\d\d)\d\d\d-\d\d\d\d' )
color = Data::Maker::Field::Format.new('#\X\X\X')
password = Data::Maker::Field::Str.new( 8 )


maker = Data::Maker.new
maker.delimiter = "\t" 
maker.record_count = 10
maker.fields = [ company, fullname ]

maker.each_record {
	|record|
	puts record.delimited
}

