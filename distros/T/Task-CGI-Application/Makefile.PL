use inc::Module::Install;

name         'Task-CGI-Application';
abstract     'Install the most common CGI::Application modules';
author       'Lyle Hopkins <cosmicnet@cpan.org>';
version_from 'lib/Task/CGI/Application.pm';
license      'perl';

# All the things we need for CGI::Application
requires     'CGI::Simple' => 0;
requires     'FCGI' => 0;
requires     'CGI::Fast' => 0;
requires     'CGI::Application' => 0;
requires     'CGI::Application::Plugin::ActionDispatch' => 0;
requires     'CGI::Application::Plugin::AnyTemplate' => 0;
requires     'CGI::Application::Plugin::AutoRunmode' => 0;
requires     'CGI::Application::Plugin::Authentication' => 0;
requires     'CGI::Application::Plugin::BREAD' => 0;
requires     'CGI::Application::Plugin::CaptureIO' => 0;
requires     'CGI::Application::Plugin::CHI' => 0;
requires     'CGI::Application::Plugin::CompressGzip' => 0;
requires     'CGI::Application::Plugin::ConfigAuto' => 0;
requires     'CGI::Application::Plugin::Config::Context' => 0;
requires     'CGI::Application::Plugin::Config::Simple' => 0;
requires     'CGI::Application::Plugin::DebugScreen' => 0;
requires     'CGI::Application::Plugin::DevPopup' => 0;
requires     'CGI::Application::Plugin::DBH' => 0;
requires     'CGI::Application::Plugin::Eparam' => 0;
requires     'CGI::Application::Plugin::ErrorPage' => 0;
requires     'CGI::Application::Plugin::Feedback' => 0;
requires     'CGI::Application::Plugin::FillInForm' => 0;
requires     'CGI::Application::Plugin::Forward' => 0;
requires     'CGI::Application::Plugin::HTDot' => 0;
requires     'CGI::Application::Plugin::HTMLPrototype' => 0;
requires     'CGI::Application::Plugin::HtmlTidy' => 0;
requires     'CGI::Application::Plugin::I18N' => 0;
requires     'CGI::Application::Plugin::JSON' => 0;
requires     'CGI::Application::Plugin::LinkIntegrity' => 0;
requires     'CGI::Application::Plugin::LogDispatch' => 0;
requires     'CGI::Application::Plugin::MessageStack' => 0;
requires     'CGI::Application::Plugin::Output::XSV' => 0;
requires     'CGI::Application::Plugin::PageBuilder' => 0;
requires     'CGI::Application::Plugin::RateLimit' => 0;
requires     'CGI::Application::Plugin::Redirect' => 0;
requires     'CGI::Application::Plugin::Routes' => 0;
requires     'CGI::Application::Plugin::RunmodeDeclare' => 0;
requires     'CGI::Application::Plugin::Session' => 0;
requires     'CGI::Application::Plugin::Stash' => 0;
requires     'CGI::Application::Plugin::Stream' => 0;
requires     'CGI::Application::Plugin::TemplateRunner' => 0;
requires     'CGI::Application::Plugin::TT' => 0;
requires     'CGI::Application::Plugin::ValidateRM' => 0;
requires     'CGI::Application::Plugin::ViewCode' => 0;
requires     'CGI::Application::Plugin::YAML' => 0;
requires     'CGI::Application::Dispatch' => 0;
requires     'CGI::Application::Dispatch::BuildURI' => 0;
requires     'CGI::Application::Dispatch::Server' => 0;
requires     'CGI::Application::FastCGI' => 0;
requires     'CGI::Application::Generator' => 0;
requires     'CGI::Application::MailPage' => 0;
requires     'CGI::Application::PhotoGallery' => 0;
requires     'CGI::Application::Search' => 0;
requires     'CGI::Application::Server' => 0;
requires     'CGI::Application::URIMapping' => 0;
requires     'Titanium' => 0;

WriteAll;
