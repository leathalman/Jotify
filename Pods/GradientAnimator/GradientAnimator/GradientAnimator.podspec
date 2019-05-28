
Pod::Spec.new do |spec|


  spec.name         = "GradientAnimator"
  spec.version      = "1.0.0"
  spec.summary      = "GradientAnimator helps to fill your view with vibrant gradient theme colours and animates them"
  spec.description  = "GradientAnimator helps to fill your view with vibrant gradient theme colours and animates them to give a stunning view to your application design. It has predefined themes and user can also initialize their own set of colors and use them to animate your background"
  spec.homepage     = "https://github.com/iLeafSolutionsPvtLtd/GradientAnimator"
  spec.license      = "MIT"
  spec.author             = { "Jaison Joseph" => "jaison@ileafsolutions.com" }
  spec.platform     = :ios, "11.0"
  spec.swift_version = '4.2'
spec.source       = { :git => "https://github.com/iLeafSolutionsPvtLtd/GradientAnimator.git",:branch => "master" ,:tag => "1.0.0" }

  spec.source_files  = "GradientAnimator", "GradientAnimator/**/*"
  spec.exclude_files = "GradientAnimator/GradientAnimator/*.plist"

end
