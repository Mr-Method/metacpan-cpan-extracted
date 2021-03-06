%define module_name Mail-MtPolicyd

Name: mtpolicyd
Version: 2.05
Release: %(date +%Y%m%d)%{dist}
Summary: a modular policy daemon for postfix

Group: Applications/CPAN
License: GPLv2
Vendor: Markus Benning <ich@markusbenning.de>
Packager: Markus Benning <ich@markusbenning.de>

BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-build

Source0: %{module_name}-%{version}.tar.gz

#AutoProv: 0

# only require core dependencies
AutoReq: 0
Requires: perl(Cache::Memcached), perl(Config::General), perl(Moose), perl(Tie::IxHash), perl(Time::HiRes), perl(DBI), perl(Mail::RBL), perl(JSON), perl(MooseX::Singleton)
BuildRequires: perl, perl(ExtUtils::MakeMaker)

Requires(pre): /usr/sbin/useradd, /usr/sbin/groupadd

%description
A modular policy daemon for postfix written in perl.

%prep
rm -rf $RPM_BUILD_ROOT
%setup -q -n %{module_name}-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

%install
if [ -d "$RPM_BUILD_ROOT" ] ; then
        rm -rf $RPM_BUILD_ROOT
fi
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} \;
find $RPM_BUILD_ROOT -type f -name perllocal.pod -exec rm -f {} \;
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null \;

mkdir -p "$RPM_BUILD_ROOT/%{_sysconfdir}/init.d"
mkdir -p "$RPM_BUILD_ROOT/%{_sysconfdir}/mtpolicyd"
mkdir -p "$RPM_BUILD_ROOT/%{_sysconfdir}/cron.d"
mkdir -p "$RPM_BUILD_ROOT/var/run/mtpolicyd"

install -m755 rpm/mtpolicyd.init-redhat "$RPM_BUILD_ROOT/%{_sysconfdir}/init.d/mtpolicyd"
install -m640 etc/mtpolicyd.conf "$RPM_BUILD_ROOT/%{_sysconfdir}/mtpolicyd/mtpolicyd.conf"
install -m640 etc/mtpolicyd.crontab "$RPM_BUILD_ROOT/%{_sysconfdir}/cron.d/mtpolicyd"

%{_fixperms} $RPM_BUILD_ROOT/*

%clean
if [ "$RPM_BUILD_ROOT" = "" -o "$RPM_BUILD_ROOT" = "/" ]; then
  RPM_BUILD_ROOT=/var/tmp/rpm-build-root
  export RPM_BUILD_ROOT
fi
rm -rf $RPM_BUILD_ROOT

%pre
( /usr/sbin/groupadd \
        -r mtpolicyd \
        && /usr/sbin/useradd \
        -c 'mtpolicyd daemon' \
        -d /var/run/mtpolicyd \
        -M -r \
         -s /bin/false \
        -g mtpolicyd \
        mtpolicyd 2>&1 >/dev/null || exit 0 )

%post
/sbin/chkconfig --add mtpolicyd

%preun
if [ "$1" = 0 ]; then
	/sbin/service mtpolicyd stop &>/dev/null
	/sbin/chkconfig --del mtpolicyd
fi

%files
%defattr(-,root,root)
%doc README
%attr(755,root,root) %{_bindir}/mtpolicyd
%attr(755,root,root) %{_bindir}/policyd-client
%attr(755,root,root) %{_sysconfdir}/init.d/mtpolicyd
%dir %ghost %{_sysconfdir}/mtpolicyd
%attr(640,root,mtpolicyd) %config(noreplace) %{_sysconfdir}/mtpolicyd/mtpolicyd.conf
%attr(640,root,root) %config %{_sysconfdir}/cron.d/mtpolicyd
%attr(750,mtpolicyd,mtpolicyd) %dir /var/run/mtpolicyd
%{perl_vendorlib}
%{_mandir}/man1/*
%{_mandir}/man3/*

%changelog
* Fri Mar 20 2015 Markus Benning <ich@markusbenning.de> 2.05
- generate spec file from upstream release

