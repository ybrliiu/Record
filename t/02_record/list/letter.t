use Record 'Test';
use Test::More;
use Test::Record;

use Record::List::Letter;
my $class = 'Record::List::Letter';
my $obj;

subtest 'new' => sub {
  $obj = $class->new(file => 'test_letter.dat', max => 100);
  isa_ok($obj, $class);
};

subtest 'make' => sub {
  $obj->data([]);
  Test::Record->makefile($obj, [qw/0 0 0 0 0 0/]);
};

done_testing;

