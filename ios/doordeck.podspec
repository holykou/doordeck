#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint doordeck.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'doordeck'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin for doordeck SDK'
  s.description      = <<-DESC
A new Flutter plugin for doordeck SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  s.dependency 'QRCodeReader.swift','~> 10.0'
  s.dependency 'ReachabilitySwift','~> 4.3'
  s.dependency 'Alamofire','~> 4.8'
  s.dependency 'Cache','~> 5.2'
  s.dependency 'Sodium','~> 0.8'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
