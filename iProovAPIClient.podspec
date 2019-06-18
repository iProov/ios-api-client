Pod::Spec.new do |s|
  s.name             = 'iProovAPIClient'
  s.version          = '0.1.0'
  s.summary          = 'Swift API Client for iProov REST API v2'
  s.homepage         = 'https://github.com/iproov/swift-api-client'
  s.license          = { :type => 'BSD-3', :file => 'LICENSE' }
  s.author           = { 'jonathanellis' => 'jonathan.ellis@iproov.com' }
  s.source           = { :git => 'https://github.com/iProov/swift-api-client.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'iProovAPIClient/Classes/**/*'

  s.dependency 'Alamofire-SwiftyJSON', '~> 3.0'
end
