package Record::Base {

  use Mouse::Role;
  
  use Record;
  use Carp qw/croak/; # モジュールでのdie;
  use Storable qw/fd_retrieve nstore_fd nstore/; # データ保存用
  
  # アテリビュート(フィールド+アクセッサ)
  has 'File' => (is => 'rw', isa => 'Str', required => 1);
  has 'FH' => (is => 'rw', isa => 'FileHandle');
  
  # インスタンス生成後処理
  sub BUILD {
    my $self = shift;
    $self->File( Record->project_dir() . $self->File );
  }
  
  # ファイルオープン
  sub open {
    my ($self, $lock) = @_;
    $lock //= '';

    # モード
    state $mode = {
      LOCK_SH => 1,    # 共有ロック
      LOCK_EX => 2,    # 排他ロック
      NB_LOCK_SH => 5, # ノンブロックな共有ロック(ノンブロックの場合、ロックできなければdie）
      NB_LOCK_EX => 6, # ノンブロックな排他ロック
    };

    if (exists $mode->{$lock}) {
      open(my $fh, '+<', $self->File) or croak "fileopen失敗:$!".$self->File;
      $self->FH($fh);
      flock($self->FH, $mode->{$lock}) or croak "flock失敗:$!";
      $self->Data(fd_retrieve $self->FH);
    } else {
      unless ($self->Data) {
        open(my $fh, '<', $self->File) or croak "fileopen失敗:$!".$self->File;
        $self->Data(fd_retrieve $fh);
        $fh->close;
      }
    }

    return $self; # メソッドチェーン用
  }
  
  # ファイル作成
  sub make {
    my $self = shift;
    nstore($self->Data, $self->File);
    return $self; # メソッドチェーン用
  }
  
  # ファイル閉じる
  sub close {
    my $self = shift;
    truncate($self->FH, 0) or croak '多分書き込みモードでファイルを開いていないか、書き込みモードで2度ファイルを開いています';
    seek($self->FH, 0, 0) or croak 'seek失敗';
    nstore_fd($self->Data, $self->FH) or croak 'nstore_fd失敗';
    $self->{Data} = undef;
    close($self->FH) or croak 'close失敗';
    return 1;
  }
  
  # ファイル削除
  sub remove {
    my $self = shift;
    unlink $self->File;
  }
  
}

1;
