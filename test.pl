#########################

use Test;
BEGIN { plan tests => 11 } ;
use Object::MultiType ;

#########################
{

  my $obj = Object::MultiType->new(
  code => sub { return ${$_[0]} } ,
  ) ;
  
  my $saver = &$obj(args) ;
  
  ok( eval { $saver->is_saver } ) ;
  
  my $self = scalar(${$$obj->{SUBCODE}{self}}) ;
  
  ok($self,undef) ;
  
}
#########################
{
  my $scalar = 'abc' ;
  my @array  = qw(x y z);
  my %hash   = (A => 1 , B => 2) ;

  my $obj = Object::MultiType->new(
  scalar => \$scalar ,
  array  => \@array ,
  hash   => \%hash ,
  ) ;
  
  my $str = sprintf('%s',$obj) ;
  ok($str,'abc');
  
  my $cp = $obj ;
  $cp .= '_x' ;
  ok($cp,'abc_x');
  
  my $array_1 = $obj->[1] ;
  ok($array_1,'y');
  
  my $hash_B = $obj->{B} ;
  ok($hash_B,'2');
  
  my $obj2 = Object::MultiType->new(
  scalarsub => sub { return 'GENDATA' } ,
  ) ;
  
  my $str2 = sprintf('%s',$obj2) ;
  ok($str2,'GENDATA');
  
}
#########################
{
  my $obj0 = Object::MultiType->new(scalar => 'obj0') ;
  my $obj1 = Object::MultiType->new(scalar => \'obj1') ;
  my $obj2 = Object::MultiType->new(scalar => \'obj2') ;
  
  ok( sprintf('%s',$obj0) ,'obj0');
  ok( sprintf('%s',$obj1) ,'obj1');
  ok( sprintf('%s',$obj2) ,'obj2');
}
#########################
{

  my $data ;

  local(*OUT) ;
  tie(*OUT , 'TestTieHandle' , \$data ) ;
  
  my $obj = Object::MultiType->new( glob => \*OUT ) ;
  print $obj "GLOB ref OK!\n" ;

  ok($data,"GLOB ref OK!\n");
  
}
#########################


package TestTieHandle ;

sub TIEHANDLE {
  bless({ data => $_[1] },__PACKAGE__) ;
}

sub PRINT {
  my $this = shift ;
  ${$this->{data}} .= join("", (@_[0..$#_])) ;
}

#########################

