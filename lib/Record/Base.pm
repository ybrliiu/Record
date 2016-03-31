package Record::Base {

  use Mouse::Role;
  
  use Record;
  use Carp qw/croak/; # モジュールでのdie;
  use Storable qw/fd_retrieve nstore_fd nstore/; # データ保存用
  
  # アテリビュート(フィールド+アクセッサ)
  has 'File' => (is => 'rw', isa => 'Str', required => 1);
  has 'FH' => (is => 'rw', isa => 'FileHandle');
# has 'Data' (...) _define_attribute($type) で動的に定義
  
  # インスタンス生成前処理
  around 'BUILDARGS' => sub {
    my ($orig, $class) = (shift, shift);
    my ($type_key, $type_value) = ($_[0], $_[1]);
    if($type_key eq 'type' && $type_value){
      $class->_define_attribute($type_value);
      shift, shift;
    }else{
      $class->_define_attribute('Any');
    }
    return $class->$orig(@_);
  };
  
  # dataアテリビュート生成
  sub _define_attribute {
    my ($class, $type) = @_;
    $class->meta->add_attribute(
      'Data',
      is => 'rw',
      isa => $class->_data_type($type), # ロール使った側で定義
    );
  }
  
  # dataアテリビュートの型(このロールを使用した側で定義)
  sub _data_type { 'Any' }
  
  # インスタンス生成後処理
  sub BUILD {
    my $self = shift;
    $self->File( Jikkoku->project_dir() . $self->File );
  }
  
  # ファイルオープン
  sub open {
    my $self = shift;
    my $lock = shift // '';
    if($lock){
      open(my $fh, '+<', $self->File) or croak 'fileopen失敗:' . $self->File;
      $self->FH($fh);
      while(!flock($self->FH,6)){ sleep(1); }
      $self->Data(fd_retrieve $self->FH);
    }else{
      open(my $fh, '<', $self->File);
      $self->FH($fh);
      $self->Data(fd_retrieve $self->FH);
      close $self->FH;
    }
    return $self; # メソッドチェーン用
  }
  
  # ファイル作成
  sub make {
    my $self = shift;
    nstore($self->Data,$self->File);
    return $self; # メソッドチェーン用
  }
  
  # ファイル閉じる
  sub close {
    my $self = shift;
    truncate($self->FH,0) or croak '多分書き込みモードでファイルを開いていないか、書き込みモードで2度ファイルを開いています';
    seek($self->FH,0,0) or croak 'seek失敗';
    nstore_fd($self->Data, $self->FH) or croak 'nstore_fd失敗';
    close $self->FH or croak 'close失敗';
  }
  
  # ファイル削除
  sub remove {
    my $self = shift;
    $ENV{MOJO_MODE} eq 'test' ? unlink $self->File : croak 'テストモードでないので使用できません';
  }
  
}

1;
