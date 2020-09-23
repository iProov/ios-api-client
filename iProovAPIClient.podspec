Pod::Spec.new do |s|
  s.name             = 'iProovAPIClient'
  s.version          = '0.3.0'
  s.summary          = 'iOS API Client for iProov REST API v2'
  s.homepage         = 'https://github.com/iproov/ios-api-client'
  s.license          = { :type => 'BSD-3', :file => 'LICENSE' }
  s.author           = { 'jonathanellis' => 'jonathan.ellis@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/ios-api-client.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'iProovAPIClient/Classes/**/*'

  s.dependency 'Alamofire', '~> 4.9' # Cannot upgrade to 5.0 as requires min deployment target 10.0
  s.dependency 'SwiftyJSON', '~> 5.0'
end
