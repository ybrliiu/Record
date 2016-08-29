use Record 'test';
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
  Test::Record->make_file(
    record => $obj,
    data   => [qw/0 0 0 0 0 0/],
    remove => 1,
  );
};

done_testing;

