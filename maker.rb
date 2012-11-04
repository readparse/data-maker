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
phone = Data::Maker::Field::Format.new( '(\d\d\d)\d\d\d-\d\d\d\d' )
color = Data::Maker::Field::Format.new( '#\X\X\X')
password = Data::Maker::Field::Str.new( 8 )

(1..count).to_a.each {
	#fields = [ fullname, ssn, phone, password, company ]
	fields = [ firstname, middlename, lastname, ssn, phone, password, company ]
	puts fields.map{|i| i.generate_value}.join("\t")
}





