Pod::Spec.new do |spec|
  spec.name                    = 'MeppSDK'
  spec.version                 = ‚1.3.1‘
  spec.summary                 = 'Mepp SDK for iOS'
  spec.author                  = { 'MEPP' => 'office@mopius.at' }
  spec.homepage                = 'https://www.mepp.at'
  spec.license                 = { :type => 'CC-ND', :file => 'LICENSE' }

  spec.module_name             = 'MeppSDK'

  spec.ios.deployment_target   = '9.0'

  spec.ios.frameworks          = 'UIKit', 'Foundation', 'SystemConfiguration', 'MobileCoreServices', 'CoreLocation', 'CoreBluetooth'

  spec.source = { :path => '.' }

  spec.ios.vendored_frameworks = 'Cocoapods/iOS/MeppSDK.framework'

  spec.requires_arc  = true

  spec.dependency 'AFDateHelper', '~> 4.0'
  spec.dependency 'Alamofire', '~> 4.0'
  spec.dependency 'AlamofireObjectMapper', '~> 4.0'
  spec.dependency 'ReachabilitySwift', '~> 3'
end
