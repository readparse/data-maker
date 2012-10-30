require 'pp'
require './datamaker.rb'

count = ARGV.shift.to_i

fullname = Data::Maker::Field::Join.new([
	Data::Maker::Field::FirstName.new,
	Data::Maker::Field::MiddleName.new,
	Data::Maker::Field::LastName.new
])

company =	Data::Maker::Field::Company.new('company')

ssn = Data::Maker::Field::SSN.new('ssn')
phone = Data::Maker::Field::Format.new( 'phone', '(\d\d\d)\d\d\d-\d\d\d\d' )
color = Data::Maker::Field::Format.new( 'color', '#\X\X\X')
password = Data::Maker::Field::Str.new( 'password', 8 )


maker = Data::Maker.new
maker.record_count = 10
maker.fields = [ company, fullname ]

maker.each_record {
	|record|
	puts record.delimited
}

