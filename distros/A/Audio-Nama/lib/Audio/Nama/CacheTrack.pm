# -------- CacheTrack ------
package Audio::Nama;
use Modern::Perl;
use Storable 'dclone';
use Audio::Nama::Globals qw(:all);

# The $args hashref passed among the subroutines in this file
# has these fields:

# track
# additional_time
# processing_time
# orig_version
# complete_caching_ref
# output_wav
# orig_volume
# orig_pan

sub cache_track { # launch subparts if conditions are met

	local $this_track;
	my $args = {}; # initialize args
	my $track;
	($track, $args->{additional_time}) = @_;
	$args->{track} = $track;
	$args->{additional_time} //= 0;
	
	pagers($track->name, ": preparing to cache.");
	
	# abort if track is a mix track for a bus and the bus is OFF 
	if( my $bus = $bn{$track->name}
		and $track->rec_status eq REC 
	 ){ 
		$bus->rw eq OFF and pagers(
			$bus->name, ": status is OFF. Aborting."), return;
	} else { 
		$track->rec_status eq PLAY or pagers(
			$track->name, ": track caching requires PLAY status. Aborting."), return;
	}
	pagers($track->name, ": nothing to cache!  Skipping."), return 
		unless 	$track->fancy_ops 
				or $track->has_insert
				or $track->is_region
				or $bn{$track->name};

	if ( prepare_to_cache($args) )
	{ 
		deactivate_vol_pan($args);
		cache_engine_run($args);
		reactivate_vol_pan($args);
		return $args->{output_wav}
	}
	else
	{ 
		throw("Empty routing graph. Aborting."); 
		return;
	}

}

sub deactivate_vol_pan {
	my $args = shift;
	unity($args->{track}, 'save_old_vol');
	pan_check($args->{track}, 50);
}
sub reactivate_vol_pan {
	my $args = shift;
	pan_back($args->{track});
	vol_back($args->{track});
}

sub prepare_to_cache {
	my $args = shift;
 	my $g = Audio::Nama::ChainSetup::initialize();
	$args->{orig_version} = $args->{track}->monitor_version;


	#   We route the signal thusly:
	#
	#   Target track --> CacheRecTrack --> wav_out
	#
	#   CacheRecTrack slaves to target target
	#     - same name
	#     - increments track version by one
	
	my $cooked = Audio::Nama::CacheRecTrack->new(
		name   => $args->{track}->name . '_cooked',
		group  => 'Temp',
		target => $args->{track}->name,
		hide   => 1,
	);

	$g->add_path($args->{track}->name, $cooked->name, 'wav_out');

	# save the output file name to return later
	
	$args->{output_wav} = $cooked->current_wav;

	# set WAV output format
	
	$g->set_vertex_attributes(
		$cooked->name, 
		{ format => signal_format($config->{cache_to_disk_format},$cooked->width),
			version => (1 + Audio::Nama::Wav::last(name => $args->{track}->name,  
										dir  => this_wav_dir())
						)
		}
	); 
	$args->{complete_caching_ref} = \&update_cache_map;

	# Case 1: Caching a standard track
	
	if($args->{track}->rec_status eq PLAY)
	{
		# set the input path
		$g->add_path('wav_in',$args->{track}->name);
		logpkg(__FILE__,__LINE__,'debug', "The graph after setting input path:\n$g");
	}

	# Case 2: Caching a bus mix track

	elsif($args->{track}->rec_status eq REC){

		# apply all buses (unneeded ones will be pruned)
		map{ $_->apply($g) } grep{ (ref $_) =~ /Sub/ } Audio::Nama::Bus::all()
	}

	logpkg(__FILE__,__LINE__,'debug', "The graph after bus routing:\n$g");
	Audio::Nama::ChainSetup::prune_graph();
	logpkg(__FILE__,__LINE__,'debug', "The graph after pruning:\n$g");
	Audio::Nama::Graph::expand_graph($g); 
	logpkg(__FILE__,__LINE__,'debug', "The graph after adding loop devices:\n$g");
	Audio::Nama::Graph::add_inserts($g);
	logpkg(__FILE__,__LINE__,'debug', "The graph with inserts:\n$g");
	my $success = Audio::Nama::ChainSetup::process_routing_graph();
	if ($success) 
	{ 
		Audio::Nama::ChainSetup::write_chains();
		Audio::Nama::ChainSetup::remove_temporary_tracks();
	}
	$success
}
sub cache_engine_run {
	my $args = shift;
	connect_transport()
		or throw("Couldn't connect engine! Aborting."), return;

	# remove fades from target track
	
	Audio::Nama::Effect::remove_op($args->{track}->fader) if defined $args->{track}->fader;

	$args->{processing_time} = $setup->{audio_length} + $args->{additional_time};

	pagers($args->{track}->name,": processing time: ". d2($args->{processing_time}). " seconds");
	pagers("Starting cache operation. Please wait.");
	
	revise_prompt(" "); 

	# we try to set processing time this way
	eval_iam("cs-set-length $args->{processing_time}"); 

	eval_iam("start");

	# ensure that engine stops at completion time
	$setup->{cache_track_args} = $args;
 	$project->{events}->{poll_engine} = AE::timer(1, 0.5, \&poll_cache_progress);

	# complete_caching() contains the remainder of the caching code.
	# It is triggered by stop_polling_cache_progress()
}
sub complete_caching {
	my $args = shift;	
	my $name = $args->{track}->name;
	my @files = grep{/$name/} new_files_were_recorded();
	if (@files ){ 
		
		$args->{complete_caching_ref}->($args) if defined $args->{complete_caching_ref};
		post_cache_processing($args);

	} else { throw("track cache operation failed!") }
	undef $setup->{cache_track_args};
}
sub update_cache_map {
	my $args = shift;
		logpkg(__FILE__,__LINE__,'debug', "updating track cache_map");
		logpkg(__FILE__,__LINE__,'debug', "current track cache entries:",
			sub {
				join "\n","cache map", 
				map{($_->dump)} Audio::Nama::EffectChain::find(track_cache => 1)
			});
		my @inserts_list = Audio::Nama::Insert::get_inserts($args->{track}->name);

		# include all ops, include vol/pan operators 
		# which serve as placeholders, won't overwrite
		# the track's current vol/pan operators

		my $track = $args->{track};
		 
		my @ops_list = @{$track->ops};
		my @ops_remove_list = $track->fancy_ops;
		
		if ( @inserts_list or @ops_remove_list or $track->is_region)
		{
			my %args = 
			(
				track_cache => 1,
				track_name	=> $track->name,
				track_version_original => $args->{orig_version},
				project => 1,
				system => 1,
				ops_list => \@ops_list,
				inserts_data => \@inserts_list,
			);
			$args{region} = [ $track->region_start, $track->region_end ] if $track->is_region;
			$args{track_target_original} = $track->target if $track->target; 
			# late, because this changes after removing target field
			map{ delete $track->{$_} } qw(target);
			$args{track_version_result} = $track->last,
			# update track settings
			my $ec = Audio::Nama::EffectChain->new( %args );
			map{ remove_effect($_) } @ops_remove_list;
			map{ $_->remove        } @inserts_list;
			map{ delete $track->{$_} } qw( region_start region_end target );

		pagers(qq(Saving effects for cached track "), $track->name, '".');
		pagers(qq('uncache' will restore effects and set version $args->{orig_version}\n));
		}
}

sub post_cache_processing {
	my $args = shift;
		# only set to PLAY tracks that would otherwise remain
		# in a REC status

		$args->{track}->set(rw => PLAY) if $args->{track}->rec_status eq 'REC';

		$ui->global_version_buttons(); # recreate
		$ui->refresh();
		revise_prompt("default"); 
}
sub poll_cache_progress {
	my $args = $setup->{cache_track_args};
	print ".";
	my $status = eval_iam('engine-status'); 
	my $here   = eval_iam("getpos");
	update_clock_display();
	logpkg(__FILE__,__LINE__,'debug', "engine time:   ". d2($here));
	logpkg(__FILE__,__LINE__,'debug', "engine status:  $status");

	return unless 
		   $status =~ /finished|error|stopped/ 
		or $here > $args->{processing_time};

	pagers("Done.");
	logpkg(__FILE__,__LINE__,'debug', engine_status(current_position(),2,1));
	#revise_prompt();
	stop_polling_cache_progress($args);
}
sub stop_polling_cache_progress {
	my $args = shift;
	$project->{events}->{poll_engine} = undef; 
	$ui->reset_engine_mode_color_display();
	complete_caching($args);

}

sub uncache_track { 
	my $track = shift;
	local $this_track;
	$track->rec_status eq PLAY or 
		throw($track->name, ": cannot uncache unless track is set to PLAY"), return;
	my $version = $track->monitor_version;
	my ($ec) = is_cached($track, $version);
	defined $ec or throw($track->name, ": version $version is not cached"), return;
	$track->fancy_ops and 
		throw($track->name, ": cannot uncache while user effects are present\n",
			"You must delete them before you can uncache this WAV version."), return;
	$track->is_region and 
		throw($track->name, ": cannot uncache while region is set for this track\n",
			"Remove it and try again."), return;
# 	$ec->inserts and $track->inserts and throw($track->name,
# 	": cannot uncache inserts because an insert is already set for this track\n",
# 	"Remove it and try again."), return;

	$ec->add($track);
	# replace track's effect list with ours
	$track->{ops} = dclone($ec->ops_list);
	# applying the the effect chain doesn't set the version or target
	# so we do it here
	$track->set(version => $ec->track_version_original);
    $track->set(target => $ec->track_target_original) if $ec->track_target_original;

	pager($track->name, ": setting uncached version ", $track->version, $/);
	pager($track->name, ": setting original region bounded by marks ", 
		$track->region_start, " and ", $track->region_end, $/)
		if $track->is_region;

	my $bus = $bn{$track->name};
	$track->set(rw => REC), pagers($track->name, ": setting mix track to REC")
		if defined $bus;
}
sub is_cached {
	my ($track, $version) = @_;
	my @results = Audio::Nama::EffectChain::find(
		project 				=> 1, 
		track_cache 			=> 1,
		track_name 				=> $track->name, 
		track_version_result 	=> $version,
	);
	scalar @results > 1 
		and warn ("more than one EffectChain matching query!, found", 
			map{ json_out($_->as_hash) } @results);
	$results[-1]
}
1;
__END__