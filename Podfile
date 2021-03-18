# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Jotify' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Jotify
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  
  pod 'Blueprints', :inhibit_warnings => true
  pod 'MultilineTextField'
  pod 'XLActionController'
  pod 'XLActionController/Skype'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['SWIFT_VERSION'] = "5"
      end
    end
  end
  
end

