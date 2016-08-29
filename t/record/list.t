use Record 'test';
use Test::More;
use Test::Record;
my $TR = Test::Record->new();

use Record::List;
my $OBJ;
my $CLASS = 'Record::List';
my $MAX = 50;

subtest 'new' => sub {
  $OBJ = $CLASS->new(
    file => 'test_list.dat',
    max => $MAX,
  );
  isa_ok($OBJ,$CLASS);
  can_ok($OBJ,qw/open make close remove/);
};

subtest 'set_alldata' => sub {
  ok $OBJ->data([0 .. 15]);
};

subtest 'get' => sub {
  my $gets = $OBJ->get(5);
  is($gets->[$_], $_) for 0 .. 4;
};

subtest 'add' => sub {
  $OBJ->add('test')->add('test2');
  my $data = $OBJ->data;
  is($data->[0], 'test2');
  is($data->[1], 'test');
};

subtest 'make' => sub {
  Test::Record->make_file(
    record => $OBJ,
    data   => [0 .. 100],
    remove => 0,
  );
  $OBJ->open();
  is(@{$OBJ->data}, $MAX, 'after_close');
  ok $OBJ->remove();
};

done_testing;
