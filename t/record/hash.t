use Record 'test';
use Test::More;
use Test::Exception;
use Test::MockObject;
use Test::Record;
my $TR = Test::Record->new();

use Record::Hash;
my $CLASS = 'Record::Hash';
my $OBJ;
my $PATH = 'test_hash.dat';

subtest 'new' => sub {
  $OBJ = $CLASS->new(file => $PATH);
  isa_ok($OBJ, $CLASS);
  can_ok($OBJ, qw/open make close remove at add delete get_list/);
};

subtest 'set_alldata' => sub {
  ok $OBJ->data({});
};

subtest 'add' => sub {
  my $str = "文章です";
  ok $OBJ->add(what => $str);
  is($OBJ->at('what'), $str);
  dies_ok { $OBJ->add('' => 'aaaa') } '空文字列キー使用';
  dies_ok { $OBJ->add(what => 'aaaa') } '既に同じキーのデータがある';
};

subtest 'update&at&exists' => sub {
  my $str = 'change';
  ok $OBJ->update(what => $str);
  is($OBJ->at('what'), $str);
  ok $OBJ->exists('what');
  ok !$OBJ->exists('hoge');
};

subtest 'search' => sub {
  my $mock = Test::MockObject->new();
  $mock->set_always(hoge => "Message");
  my $record = $CLASS->new(file => $PATH);
  $record->add(hoge => $mock);
  ok my ($result) = ($record->search(hoge => "Message"));
  is($result->hoge, "Message");
  ok 1;
};

subtest 'delete' => sub {
  ok $OBJ->delete('what');
  dies_ok { $OBJ->at('what') }
};

subtest 'filedir' => sub {
  like($OBJ->file, qr/$PATH/);
};

subtest 'make' => sub {
  Test::Record->make_file(
    record => $OBJ,
    data   => {qw/a b c d e f/},
    remove => 1,
  );
};

done_testing;
