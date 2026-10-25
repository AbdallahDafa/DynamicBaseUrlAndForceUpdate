#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint dynamic_base_url_and_force_update.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'dynamic_base_url_and_force_update'
  s.version          = '0.0.1'
  s.summary          = 'Dynamic change base url & force update new version from Google Play and Apple Store.'
  s.description      = <<-DESC
Dynamic change base url & force update new version from Google Play and Apple Store.
                       DESC
  s.homepage         = 'https://github.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'dynamic_base_url_and_force_update/Sources/dynamic_base_url_and_force_update/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
