#
#  Be sure to run `pod spec lint ScrollPage.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ScrollPage"
  s.version      = "1.1.0"
  s.summary      = "ScrollPage is a custom control which is mixture of UIScrollView contains Container Views and Scrollable Tab Bar."
  s.description  = "ScrollPage is a custom control which is mixture of UIScrollView contains Container Views and Scrollable Tab Bar. Different from SMSwipeableTabView which used PageViewController. Use UIScrollView to get more flexibility."

  s.homepage     = "https://github.com/dan12411/ScrollPage"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "TeCheng Hung" => "dan12411@gmail.com" }
  s.social_media_url   = "https://twitter.com/techenghung"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/dan12411/ScrollPage.git", :tag => "1.0.3" }

  s.source_files  = "ScrollPage", "ScrollPage/**/*.{h,m,swift}"
  s.frameworks = 'Foundation', 'UIKit'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

end
