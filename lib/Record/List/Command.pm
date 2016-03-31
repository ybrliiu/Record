package Record::List::Command {
  
  use Mouse;
  extends 'Record::List'; # 継承
  
  use Record;
  
  # コマンド入力
  sub input {
    my ($self, $input_obj, $input_list) = @_;
    my $command = $self->Data;
    splice(@$command, $_, 1, $input_obj) for (@$input_list);
    $self->Data($command);
    return $self;
  }
  
  # コマンド削除
  sub delete {
    my ($self, $none_obj, $delete_list) = @_;
    my $command = $self->input('delete', $delete_list)->Data; # 目印つける
    @$command = map { $_ eq 'delete' ? () : $_ } @$command; # 目印をつけたデータを削除
    my @empty = map { $none_obj } 0 .. @$delete_list; # 空データを削除した個数分作って
    push(@$command,@empty); # コマンドの配列の後ろに挿入
    $self->Data($command);
    return $self;
  }
  
  # 空白注入
  sub insert {
    my ($self, $none_obj, $no, $num) = @_;
    my $command = $self->Data;
    my @insert = map { $none_obj } 0 .. $num-1;
    splice(@$command, $no, 0, @insert); # $no の配列に@insertを挿入
    $self->Data($command);
    return $self;
  } 
  
  __PACKAGE__->meta->make_immutable();
}

1;

