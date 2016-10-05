Pod::Spec.new do |spec|
  spec.name                    = 'MeppSDK'
  spec.version                 = '1.0.5'
  spec.summary                 = 'Mepp SDK for iOS'
  spec.author                  = { 'MEPP' => 'office@mopius.at' }
  spec.homepage                = 'https://www.mepp.at'
  spec.license                 = { :type => 'CC-ND', :file => 'LICENSE' }

  spec.module_name             = 'MeppSDK'

  spec.ios.deployment_target   = '8.0'

  spec.ios.frameworks          = 'UIKit', 'Foundation', 'SystemConfiguration', 'MobileCoreServices', 'CoreLocation', 'CoreBluetooth'

  spec.source = { :path => '.' }

  spec.ios.vendored_frameworks = 'Cocoapods/iOS/MeppSDK.framework'

  spec.requires_arc  = true
  
  spec.dependency 'AFDateHelper', '3.4.2'
  spec.dependency 'Alamofire', '3.5.1'
  spec.dependency 'AlamofireObjectMapper', '3.0.2'
  spec.dependency 'KontaktSDK', '1.2.3'
  spec.dependency 'ObjectMapper', '1.5.0'
  spec.dependency 'ReachabilitySwift', '2.4'
end
