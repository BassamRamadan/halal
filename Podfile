# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'fruitsApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end

  # Pods for fruitsApp
pod 'DropDown'
pod 'SDWebImage'
pod 'IQKeyboardManagerSwift'
pod 'NVActivityIndicatorView', '~> 4.7.0'
pod 'GoogleMaps', '~> 3.3.0'
pod 'GooglePlaces', '~> 3.3.0'
pod 'PopupDialog'
pod 'ObjectMapper', '~> 3.5.1'
pod 'Alamofire', '~> 4.8.2'
pod 'AlamofireObjectMapper', '~> 5.2.0'
pod 'AlamofireImage', '~> 3.5.2'
pod 'Firebase', '~> 6.6.0'
end
