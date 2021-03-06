#!/usr/bin/env perl

=head1 NAME
=head1 SYNOPSIS
=head1 DESCRIPTION
=head1 CONTACT
=head1 METHODS

=cut

BEGIN { unshift(@INC, './modules') }
use strict;
use warnings;
no warnings 'uninitialized';
use POSIX;
use Getopt::Long;
use VRTrack::VRTrack;
use VertRes::Utils::VRTrackFactory;
use Data::Dumper;
use Parallel::ForkManager;

use UpdatePipeline::UpdateAllMetaData;
use UpdatePipeline::Studies;

my ( $studyfile, $help, $number_of_files_to_return, $parallel_processes, $verbose_output, $errors_min_run_id, $database,$input_study_name );

GetOptions(
    's|studies=s'              => \$studyfile,
    'n|study_name=s'           => \$input_study_name,
    'd|database=s'             => \$database,
    'f|max_files_to_return=s'  => \$number_of_files_to_return,
    'p|parallel_processes=s'   => \$parallel_processes,
    'v|verbose'                => \$verbose_output,
    'r|min_run_id=s'             => \$errors_min_run_id,
    'h|help'                   => \$help,
);

my $db = $database ;

( ($studyfile || $input_study_name) &&  $db && !$help ) or die <<USAGE;
Usage: $0   
  -s|--studies             <file of study names>
  -n|--study_name          <a single study name to update>
  -d|--database            <vrtrack database name>
  -f|--max_files_to_return <optional limit on num of file to check per process>
  -p|--parallel_processes  <optional number of processes to run in parallel, defaults to 1>
  -v|--verbose             <print out debugging information>
  -r|--min_run_id          <optionally filter out errors below this run_id, defaults to 6000>
  -h|--help                <this message>

Update the tracking database from IRODs and the warehouse.

# update all studies listed in the file in the given database
$0 -s my_study_file -d pathogen_abc_track

# update only the given study
$0 -n "My Study" -d pathogen_abc_track

# Lookup all studies listed in the file, but only update the 500 latest files in IRODs
$0 -s my_study_file -d pathogen_abc_track -f 500

# perform the update using 10 processes
$0 -s my_study_file -d pathogen_abc_track -p 10

USAGE

$parallel_processes ||= 1;
$verbose_output ||= 0;
$errors_min_run_id ||= 6000;
my $study_names;

if(defined($studyfile))
{
  $study_names = UpdatePipeline::Studies->new(filename => $studyfile)->study_names;
}
else
{
  my @studyname = ($input_study_name);
  $study_names = \@studyname;
}

if($parallel_processes == 1)
{
  my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(database => $db,mode     => 'rw');
  unless ($vrtrack) { die "Can't connect to tracking database: $db \n";}
  my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => $study_names, _vrtrack => $vrtrack, number_of_files_to_return =>$number_of_files_to_return, verbose_output => $verbose_output, minimum_run_id => $errors_min_run_id  );
  $update_pipeline->update();
}
else
{
  my $pm = new Parallel::ForkManager($parallel_processes); 
  foreach my $study_name (@{$study_names}) {
    $pm->start and next; # do the fork
    my @split_study_names;
    push(@split_study_names, $study_name);
    
    my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(database => $db,mode     => 'rw');
    unless ($vrtrack) { die "Can't connect to tracking database: $db \n";}
    my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => \@split_study_names, _vrtrack => $vrtrack, number_of_files_to_return =>$number_of_files_to_return, verbose_output => $verbose_output, minimum_run_id => $errors_min_run_id  );
    $update_pipeline->update();
    $pm->finish; # do the exit in the child process
  }
  $pm->wait_all_children;
}



