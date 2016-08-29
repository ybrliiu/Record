use Record 'test';
use Test::More;
use Test::Record;
use Test::Exception;

use Record::List::CommandList;
my $class = 'Record::List::CommandList';
my $obj;

subtest 'new' => sub {
  $obj = $class->new(file => 'test_command_list.dat', max => 15);
  isa_ok($obj, $class);
};

subtest 'at' => sub {
  $obj->data([0 .. 14]);
  is($obj->at(5), 5);
  dies_ok { $obj->at(15) };
};

subtest 'save' => sub {
  ok $obj->save(5, 'save_data');
  is($obj->at(5), 'save_data');
};

subtest 'make' => sub {
  Test::Record->make_file(
    record => $obj,
    data   => [qw/0 0 0 0 0 0/],
    remove => 1,
  );
};

done_testing;

