Pod::Spec.new do |s|
  s.name             = 'iProovAPIClient'
  s.version          = '2.1.0'
  s.summary          = 'iOS API Client for iProov REST API v2'
  s.homepage         = 'https://github.com/iProov/ios-api-client'
  s.license          = { :type => 'BSD-3', :file => 'LICENSE.md' }
  s.author           = { 'iProov' => 'support@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios-api-client.git', :tag => s.version.to_s }
  s.swift_version = '5.7'
  s.ios.deployment_target = '13.0'
  s.source_files = 'Sources/iProovAPIClient/**/*'
  s.dependency 'Alamofire', '~> 5.0'
end
