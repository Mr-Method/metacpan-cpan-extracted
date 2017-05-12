# generated by wxGlade 0.7.2 on Thu Jan 19 16:56:16 2017
#
# To get wxPerl visit http://www.wxperl.it
#

use Wx 0.15 qw[:allclasses];
use strict;
# begin wxGlade: dependencies
use Wx::Locale gettext => '_T';
# end wxGlade

# begin wxGlade: extracode
# end wxGlade

package App::Music::ChordPro::Wx::Main_wxg;

use Wx qw[:everything];
use base qw(Wx::Frame);
use strict;

# begin wxGlade: dependencies
use Wx::Locale gettext => '_T';
# end wxGlade

sub new {
    my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
    $parent = undef              unless defined $parent;
    $id     = -1                 unless defined $id;
    $title  = ""                 unless defined $title;
    $pos    = wxDefaultPosition  unless defined $pos;
    $size   = wxDefaultSize      unless defined $size;
    $name   = ""                 unless defined $name;

    # begin wxGlade: App::Music::ChordPro::Wx::Main_wxg::new
    $style = wxDEFAULT_FRAME_STYLE 
        unless defined $style;

    $self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );
    

    # Menu Bar

    $self->{main_menubar} = Wx::MenuBar->new();
    use constant wxID_HELP_ChordPro => Wx::NewId();
    use constant wxID_HELP_Config => Wx::NewId();
    my $wxglade_tmp_menu;
    $wxglade_tmp_menu = Wx::Menu->new();
    $wxglade_tmp_menu->Append(wxID_NEW, _T("New"), _T("Create a new ChordPro document"));
    $wxglade_tmp_menu->Append(wxID_OPEN, _T("Open...	Ctrl-O"), _T("Open an existing ChordPro file"));
    $wxglade_tmp_menu->AppendSeparator();
    $wxglade_tmp_menu->Append(wxID_PREVIEW, _T("Preview	Ctrl-P"), _T("Format and preview"));
    $wxglade_tmp_menu->Append(wxID_SAVE, _T("Save...	Ctrl-S"), _T("Save the current ChordPro file"));
    $wxglade_tmp_menu->AppendSeparator();
    $wxglade_tmp_menu->Append(wxID_EXIT, _T("Exit"), "");
    $self->{main_menubar}->Append($wxglade_tmp_menu, _T("File"));
    $wxglade_tmp_menu = Wx::Menu->new();
    $wxglade_tmp_menu->Append(wxID_UNDO, _T("Undo"), "");
    $wxglade_tmp_menu->Append(wxID_REDO, _T("Redo"), "");
    $wxglade_tmp_menu->AppendSeparator();
    $wxglade_tmp_menu->Append(wxID_CUT, _T("Cut"), "");
    $wxglade_tmp_menu->Append(wxID_COPY, _T("Copy"), "");
    $wxglade_tmp_menu->Append(wxID_PASTE, _T("Paste"), "");
    $wxglade_tmp_menu->Append(wxID_DELETE, _T("Delete"), "");
    $wxglade_tmp_menu->AppendSeparator();
    $wxglade_tmp_menu->Append(wxID_PREFERENCES, _T("Preferences..."), _T("Preferences"));
    $self->{main_menubar}->Append($wxglade_tmp_menu, _T("Edit"));
    $wxglade_tmp_menu = Wx::Menu->new();
    $wxglade_tmp_menu->Append(wxID_HELP_ChordPro, _T("ChordPro file format"), _T("Help about the ChordPro file format"));
    $wxglade_tmp_menu->Append(wxID_HELP_Config, _T("ChordPro config files"), _T("Help about the config files"));
    $wxglade_tmp_menu->AppendSeparator();
    $wxglade_tmp_menu->Append(wxID_ABOUT, _T("About"), _T("About WxChordPro"));
    $self->{main_menubar}->Append($wxglade_tmp_menu, _T("Help"));
    $self->SetMenuBar($self->{main_menubar});
    
    # Menu Bar end

    $self->{f_main_statusbar} = $self->CreateStatusBar(1);
    $self->{t_source} = Wx::TextCtrl->new($self, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, wxTE_MULTILINE);

    $self->__set_properties();
    $self->__do_layout();

    Wx::Event::EVT_MENU($self, wxID_NEW, $self->can('OnNew'));
    Wx::Event::EVT_MENU($self, wxID_OPEN, $self->can('OnOpen'));
    Wx::Event::EVT_MENU($self, wxID_PREVIEW, $self->can('OnPreview'));
    Wx::Event::EVT_MENU($self, wxID_SAVE, $self->can('OnSave'));
    Wx::Event::EVT_MENU($self, wxID_EXIT, $self->can('OnQuit'));
    Wx::Event::EVT_MENU($self, wxID_UNDO, $self->can('OnUndo'));
    Wx::Event::EVT_MENU($self, wxID_REDO, $self->can('OnRedo'));
    Wx::Event::EVT_MENU($self, wxID_CUT, $self->can('OnCut'));
    Wx::Event::EVT_MENU($self, wxID_COPY, $self->can('OnCopy'));
    Wx::Event::EVT_MENU($self, wxID_PASTE, $self->can('OnPaste'));
    Wx::Event::EVT_MENU($self, wxID_DELETE, $self->can('OnDelete'));
    Wx::Event::EVT_MENU($self, wxID_PREFERENCES, $self->can('OnPreferences'));
    Wx::Event::EVT_MENU($self, wxID_HELP_ChordPro, $self->can('OnHelp_ChordPro'));
    Wx::Event::EVT_MENU($self, wxID_HELP_Config, $self->can('OnHelp_Config'));
    Wx::Event::EVT_MENU($self, wxID_ABOUT, $self->can('OnAbout'));

    # end wxGlade
    return $self;

}


sub __set_properties {
    my $self = shift;
    # begin wxGlade: App::Music::ChordPro::Wx::Main_wxg::__set_properties
    $self->SetTitle(_T("ChordPro"));
    $self->SetSize($self->ConvertDialogSizeToPixels(Wx::Size->new(401, 311)));
    $self->{f_main_statusbar}->SetStatusWidths(-1);

    # statusbar fields
    my( @f_main_statusbar_fields ) = (
        _T("f_main_statusbar"),
    );

    if( @f_main_statusbar_fields ) {
        $self->{f_main_statusbar}->SetStatusText($f_main_statusbar_fields[$_], $_)
        for 0 .. $#f_main_statusbar_fields ;
    }
    # end wxGlade
}

sub __do_layout {
    my $self = shift;
    # begin wxGlade: App::Music::ChordPro::Wx::Main_wxg::__do_layout
    $self->{sz_outer} = Wx::BoxSizer->new(wxVERTICAL);
    $self->{sz_main} = Wx::BoxSizer->new(wxVERTICAL);
    $self->{sz_source} = Wx::StaticBoxSizer->new(Wx::StaticBox->new($self, wxID_ANY, ""), wxHORIZONTAL);
    $self->{sz_source}->Add($self->{t_source}, 1, wxALL|wxEXPAND, 5);
    $self->{sz_main}->Add($self->{sz_source}, 1, wxALL|wxEXPAND, 5);
    $self->{sz_outer}->Add($self->{sz_main}, 1, wxEXPAND, 0);
    $self->SetSizer($self->{sz_outer});
    $self->Layout();
    # end wxGlade
}

sub OnNew {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnNew <event_handler>
    warn "Event handler (OnNew) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnOpen {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnOpen <event_handler>
    warn "Event handler (OnOpen) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnPreview {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnPreview <event_handler>
    warn "Event handler (OnPreview) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnSave {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnSave <event_handler>
    warn "Event handler (OnSave) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnQuit {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnQuit <event_handler>
    warn "Event handler (OnQuit) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnUndo {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnUndo <event_handler>
    warn "Event handler (OnUndo) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnRedo {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnRedo <event_handler>
    warn "Event handler (OnRedo) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnCut {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnCut <event_handler>
    warn "Event handler (OnCut) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnCopy {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnCopy <event_handler>
    warn "Event handler (OnCopy) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnPaste {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnPaste <event_handler>
    warn "Event handler (OnPaste) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnDelete {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnDelete <event_handler>
    warn "Event handler (OnDelete) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnPreferences {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnPreferences <event_handler>
    warn "Event handler (OnPreferences) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnHelp_ChordPro {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnHelp_ChordPro <event_handler>
    warn "Event handler (OnHelp_ChordPro) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnHelp_Config {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnHelp_Config <event_handler>
    warn "Event handler (OnHelp_Config) not implemented";
    $event->Skip;
    # end wxGlade
}


sub OnAbout {
    my ($self, $event) = @_;
    # wxGlade: App::Music::ChordPro::Wx::Main_wxg::OnAbout <event_handler>
    warn "Event handler (OnAbout) not implemented";
    $event->Skip;
    # end wxGlade
}


# end of class App::Music::ChordPro::Wx::Main_wxg

1;

