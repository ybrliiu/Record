# データ記録のテストメソッド集

package Test::Record {

  use Record;
  use Test::More;

  # データ記録ファイルを実際に作成、読み込み、書き込み、削除するテスト
  sub makefile {
    my ($class, $obj, $data) = @_;
    ok $obj->make;
    ok $obj->open;
    ok $obj->open(1);
    ok $obj->Data($data);
    ok $obj->close;
    ok $obj->remove;
  }

}

1;
