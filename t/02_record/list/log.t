use Record 'Test';
use Test::More;
use Test::Record;

use Record::List::Log;
my $class = 'Record::List::Log';
my $obj;

subtest 'new' => sub {
  $obj = $class->new(File => 'test_log.dat', Max => 100);
  isa_ok($obj, $class);
};

subtest 'make' => sub {
  $obj->Data([]);
  Test::Record->makefile($obj, [qw/0 0 0 0 0 0/]);
};

done_testing;

