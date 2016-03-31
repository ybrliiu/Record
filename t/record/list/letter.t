use Record 'Test';
use Test::More;
use Test::Record;

use Record::List::Letter;
my $class = 'Record::List::Letter';
my $obj;

subtest 'new' => sub {
  $obj = $class->new(File => 'test_letter.dat', Max => 100);
  isa_ok($obj, $class);
};

subtest 'make' => sub {
  $obj->Data([]);
  Test::Record->makefile($obj, [qw/0 0 0 0 0 0/]);
};

done_testing;

