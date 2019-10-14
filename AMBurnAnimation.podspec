Pod::Spec.new do |s|
s.name         = "AMBurnAnimation"
s.version      = "2.1.0"
s.summary      = "AMBurnAnimation is a UIView extension can display animation of burning view."
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.homepage     = "https://github.com/adventam10/AMBurnAnimation"
s.author       = { "am10" => "adventam10@gmail.com" }
s.source       = { :git => "https://github.com/adventam10/AMBurnAnimation.git", :tag => "#{s.version}" }
s.platform     = :ios, "9.0"
s.requires_arc = true
s.source_files = 'Source/*.{swift}'
s.resources    = 'Source/**/*.{png}'
s.swift_version = "5.0"
end
