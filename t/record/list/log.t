use Record 'test';
use Test::More;
use Test::Record;
my $TR = Test::Record->new();

use Record::List::Log;
my $CLASS = 'Record::List::Log';
my $OBJ;

subtest 'new' => sub {
  $OBJ = $CLASS->new(file => 'test_log.dat', max => 100);
  isa_ok($OBJ, $CLASS);
};

subtest 'make' => sub {
  $OBJ->data([]);
  Test::Record->make_file(
    record => $OBJ,
    data   => [qw/0 0 0 0 0 0/],
    remove => 1,
  );
};

done_testing;

