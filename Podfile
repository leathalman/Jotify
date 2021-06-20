# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Jotify' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # There are several implicit warning after the upgrade to Swift 5.4
  inhibit_all_warnings!
  
  # Pods for Jotify
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  
  pod 'Blueprints'
  pod 'MultilineTextField'
  pod 'Pageboy', '~> 3.6'
  pod 'SwiftMessages'
  pod 'ViewAnimator', '~> 2.7.0'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['SWIFT_VERSION'] = "5"
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
  
end

