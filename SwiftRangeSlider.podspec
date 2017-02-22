Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "SwiftRangeSlider"
s.summary = "A Swift implementation of a custom UIControl for selecting a range of values on a slider bar."
s.requires_arc = true

s.version = "0.7.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Brian Corbin" => "brian.william.corbin@gmail.com" }
s.homepage = "https://github.com/BrianCorbin/SwiftRangeSlider"
s.source = { :git => "https://github.com/BrianCorbin/SwiftRangeSlider.git", :tag => "#{s.version}"}

s.framework = "UIKit"

s.source_files = "SwiftRangeSlider/**/*.{swift}"
#s.resources = "SwiftRangeSlider/**/*.{png,jpeg,jpg,storyboard,xib}"

end
