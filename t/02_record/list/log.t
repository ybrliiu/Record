use Record 'Test';
use Test::More;
use Test::Record;

use Record::List::Log;
my $class = 'Record::List::Log';
my $obj;

subtest 'new' => sub {
  $obj = $class->new(file => 'test_log.dat', max => 100);
  isa_ok($obj, $class);
};

subtest 'make' => sub {
  $obj->data([]);
  Test::Record->make_file(
    record => $obj,
    data   => [qw/0 0 0 0 0 0/],
    remove => 1,
  );
};

done_testing;

