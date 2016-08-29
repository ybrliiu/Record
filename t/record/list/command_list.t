use Record 'test';
use Test::More;
use Test::Record;
my $TR = Test::Record->new();
use Test::Exception;

use Record::List::CommandList;
my $CLASS = 'Record::List::CommandList';
my $OBJ;

subtest 'new' => sub {
  $OBJ = $CLASS->new(file => 'test_command_list.dat', max => 15);
  isa_ok($OBJ, $CLASS);
};

subtest 'at' => sub {
  $OBJ->data([0 .. 14]);
  is($OBJ->at(5), 5);
  dies_ok { $OBJ->at(15) };
};

subtest 'save' => sub {
  ok $OBJ->save(5, 'save_data');
  is($OBJ->at(5), 'save_data');
};

subtest 'make' => sub {
  Test::Record->make_file(
    record => $OBJ,
    data   => [qw/0 0 0 0 0 0/],
    remove => 1,
  );
};

done_testing;

