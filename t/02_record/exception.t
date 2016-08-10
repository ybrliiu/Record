use Record 'Test';
use Test::More; # テストモジュール
use Test::Exception; # 例外を伴うテスト

use Record::Exception;
my $class = 'Record::Exception';

subtest 'throw exception' => sub {
  throws_ok {
    $class->throw(
      message => 'test_throw',
      obj => {},
    )
  } qr/test_throw/, 'throw success';
};

subtest 'operation verification' => sub {
  eval {
    $class->throw(
      message => 'test_throw',
      obj => {something => 'ほげほげ'},
    )
  };
  my $e = $@;
  ok $class->caught($e), 'discriminate error';
  is $e->obj->{something}, 'ほげほげ', '例外投げた時のデータ確認';
  like $e, qr/test_throw at t\/02_record\/exception.t line /, 'メッセージ確認';
  diag $e;
};

done_testing;
