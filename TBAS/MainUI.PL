#!/usr/bin/perl -w
# Taobao business Aid System
#Author-Robot Boy

our $splash;
BEGIN {
        require Tk::Splash;
        my $image="image/robotwindow.gif"; 
	my $width=434;
	my $height=268;
	my $title="hello";
	my $overrideredirect=1;
        $splash = Tk::Splash->Show($image, $width, $height, $title,
                                   $overrideredirect);
}
       
use Tk;
use Tk::Splash;
use Encode;
use Encode::CN;
use open IN=>':encoding("gb2312")';
use strict;
use TBAS;
use Cwd;

our $state=0;
my $repeat2;
our $moduledir=decode("gbk",getcwd);;

our $dir="$moduledir/records";
my $ver = "1.0.2";



print "Start GUI\n";	

#MainWindow
our $mw = MainWindow->new;
$mw->configure(-bg=>"#9AC0CD");
$mw->geometry("800x600+240+80");
$mw->resizable( 0, 0 );
my $titletxt=decode("gbk","����������֮�Ա��̼Ҹ���");
$mw->title("$titletxt");
$mw->Label(-text =>$titletxt,-font=>[-size=>24],-bg=>"#9AC0CD")->pack();


#menu
my $main_menu = $mw->Menu();
$mw->configure(-menu => $main_menu);
#file
my $file_menu = $main_menu->cascade(-label=>decode(("gbk"),"�ļ�"), -underline => 0, -tearoff=>0);
$file_menu->command(-label=>decode(("gbk"),"��·��..."), -underline=>0, -command =>\&choosetalkingfilepath);
$file_menu->command(-label=>decode(("gbk"),"�˳�"), -underline=>0, -command => sub{exit});
#config

#run
my $run_menu = $main_menu->cascade(-label=>decode(("gbk"),"����"), -underline => 0, -tearoff=>0);
$run_menu->command(-label=>decode(("gbk"),"����"), -underline=>0, -command =>\&parsefile);
$run_menu->command(-label=>decode(("gbk"),"ֹͣ"), -underline=>0, -command =>\&stopparsefile);
$run_menu->command(-label=>decode(("gbk"),"���"), -underline=>0, -command => \&clearrecords);
$run_menu->command(-label=>decode(("gbk"),"����"), -underline=>0, -command => \&resetrecords);
#help
my $help_menu = $main_menu->cascade(-label =>decode(("gbk"), "����"), -underline => 0, -tearoff => 0);
$help_menu->command(-label =>decode(("gbk"), "�汾"), -underline => 0,-command => sub{$mw->messageBox(-message => decode(("gbk"),"�汾: $ver"),-type => "ok")});
$help_menu->command(-label =>decode(("gbk"), "���ڻ���������"), -underline => 0, -command => \&show_about);

our  $txt = $mw->Scrolled(
        'Text',
        -background => 'white',
        -foreground => 'black',
        -height     => '30',
        -takefocus  => '0',
        -width      => '110',
        -scrollbars => 'oe'
    )->pack;


my $filetag=$mw->Label(-text =>decode(("gbk"),"��ǰ����:"),-bg=>"#9AC0CD")->place(-x => 10, -y =>480);
my $filelab=$mw->Label(-text => $dir,-bg=>"#9AC0CD")->place(-x => 70, -y =>480);

#shortcut
my $parsebutton = $mw->Button(-text => decode(("gbk"),"��������"),-relief=>"raised" ,-activeforeground => "#8B0000",-activebackground => "#43CD80", -command => \&parsefile)->place(-x => 400, -y =>500);
my $stopbutton = $mw->Button(-text =>decode(("gbk"), "ֹͣ����"),-relief=>"raised" ,-activeforeground => "#8B0000",-activebackground => "#43CD80", -command => \&stopparsefile)->place(-x => 500, -y =>500);
my $clearbutton = $mw->Button(-text =>decode(("gbk"), "�����¼"),-relief=>"raised" ,-activeforeground => "#8B0000",-activebackground => "#43CD80", -command => \&clearrecords)->place(-x => 600, -y =>500);
my $resetbutton = $mw->Button(-text => decode(("gbk"),"����"),-relief=>"raised" ,-activeforeground => "#8B0000",-activebackground => "#43CD80", -command => \&resetrecords)->place(-x => 700, -y =>500);

#notice!
my $noticetext=decode("gbk","����ʱ������ɧ�ţ�");
$txt -> Insert("\n$noticetext\n ");
#sleep 2;
$splash->Destroy if($splash) ;



MainLoop;



sub choosetalkingfilepath
{
    my $tmp = $mw->chooseDirectory(-initialdir => '~',-title => 'choose a directory');
    if (!defined $tmp) {
        warn 'No directory selected';
        my $notice1=decode("gbk","û��ѡ���ļ��У�");
	$txt -> Insert("\n$notice1\n ");
	$dir=$notice1;
	$filelab->configure(-text => $dir);
    } else {
        warn "Selected $tmp";
        $dir=decode("gbk",$tmp);
        $filelab->configure(-text => $dir);
        my $notice2=decode("gbk","��ѡ����ļ�����:");
	$txt -> Insert("\n$notice2 $dir\n ");
   }
}

sub stopparsefile{

   $state=0;
   
}



sub parsefile{
        if($dir eq decode("gbk","û��ѡ���ļ��У�"))
        {
        	my $notice=decode("gbk","��ѡ�������¼���ڵ��ļ��У�");
        	$txt -> Insert("\n$notice\n ");
        }
        else
        {
	        $repeat2 = $mw->after( 110 =>\&dothings );
	
        }
        	
}


sub dothings{

	my $notice=decode("gbk","��ʼ����!...");
	$txt -> Insert("\n$notice \n ");
	$state=1;


	TBAS::GetRecordsFiles();
    
	$notice=decode("gbk","��������!...");
	$txt -> Insert("\n$notice \n ");
	TBAS::InitVariables();
	$state = 0;

}

sub clearrecords
{

  $txt ->delete('1.0','end');

}

sub resetrecords
{
  $txt ->delete('1.0','end');	
  $state=0;
  $dir="$moduledir/records";
  $filelab->configure(-text => $dir);
  my $notice=decode("gbk","��ѡ����ļ����ǣ�");
  $txt -> Insert("\n$notice $dir\n ");
  TBAS::InitVariables();	
	
}


sub show_about 
{
  my $help_win =$mw->Toplevel;
  $help_win->resizable( 0, 0 );
  $help_win->geometry("300x100+340+340");
  my $abouttext=decode(("gbk"),"���ڻ�����");
  $help_win->title("$abouttext");
  my $help_msg = decode(("gbk"),"����������ϵ�п��԰������򻯰칫�����Ч��!\n ��������ϵ��lingtongshen\@gmail.com \n QQ:758616242 \n MSN:boytong1982\@hotmal.com");
  $help_win->Label(-text => $help_msg)->pack();
  $help_win->Button(-text => decode(("gbk"),"ȷ��"), -command => [$help_win => 'destroy'])->pack();
}