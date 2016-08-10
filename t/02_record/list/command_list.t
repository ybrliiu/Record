use Record 'Test';
use Test::More;
use Test::Record;

use Record::List::CommandList;
my $class = 'Record::List::CommandList';
my $obj;

subtest 'new' => sub {
  $obj = $class->new(file => 'test_command_list.dat', max => 15);
  isa_ok($obj, $class);
};

subtest 'find' => sub {
  $obj->data([0 .. 14]);
  is($obj->find(5), 5);
};

subtest 'update' => sub {
  ok $obj->update(5, 'update_data');
  is($obj->find(5), 'update_data');
};

subtest 'make' => sub {
  Test::Record->makefile($obj, [qw/0 0 0 0 0 0/]);
};

done_testing;

