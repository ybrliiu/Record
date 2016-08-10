# データ記録のテストメソッド集

package Test::Record {

  use Record;
  use Test::More;

  # データ記録ファイルを実際に作成、読み込み、書き込み、削除するテスト
  sub makefile {
    my ($class, $obj, $data, $dont_remove) = @_;
    $dont_remove //= '';
    ok $obj->make;
    ok $obj->open;
    ok $obj->open('LOCK_EX');
    ok $obj->data($data);
    ok $obj->close;
    ok $obj->remove unless $dont_remove;
  }

}

1;
