use Record 'test';
use Test::More; # テストモジュール
use Test::Exception; # 例外を伴うテスト
use Test::MockObject; # モックオブジェクト
use Test::Record; # テストメソッド集

use Record::Hash;
my $class = 'Record::Hash';
my $obj;
my $dir = 'test_hash.dat';

subtest 'new' => sub {
  $obj = $class->new(file => $dir);
  isa_ok($obj,$class);
  can_ok($obj,qw/open make close remove find add delete get_list/);
};

subtest 'set_alldata' => sub {
  ok $obj->data({});
};

subtest 'add' => sub {
  my $str = "文章です";
  ok $obj->add(what => $str);
  is($obj->data->{what}, $str);
  dies_ok { $obj->add('' => 'aaaa') } '空文字列キー使用';
  dies_ok { $obj->add(what => 'aaaa') } '既に同じキーのデータがある';
};

subtest 'update&find&exists' => sub {
  my $str = 'change';
  ok $obj->update(what => $str);
  is($obj->find('what'), $str);
  ok $obj->exists('what');
  ok !$obj->exists('hoge');
};

subtest 'search' => sub {
  my $mock = Test::MockObject->new();
  $mock->set_always(hoge => "Message");
  my $record = $class->new(file => $dir);
  $record->add(hoge => $mock);
  ok my ($result) = ($record->search(hoge => "Message"));
  is($result->hoge, "Message");
  ok 1;
};

subtest 'delete' => sub {
  ok $obj->delete('what');
  dies_ok { $obj->find('what') }
};

subtest 'filedir' => sub {
  like($obj->file, qr/$dir/);
};

subtest 'make' => sub {
  Test::Record->make_file(
    record => $obj,
    data   => {qw/a b c d e f/},
    remove => 1,
  );
};

done_testing;
