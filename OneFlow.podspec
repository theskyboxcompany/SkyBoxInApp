#
# Be sure to run `pod lib lint OneFlow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OneFlow'
  s.version          = '1.0.1'
  s.summary          = 'InApp purchase with local receipt verification.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Used to hanlde subscription InApp purchase with local receipt verification.'

  s.homepage         = 'https://github.com/theskyboxcompany/OneFlow'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rohantryskybox' => 'rohan@tryskybox.com' }
  s.source           = { :git => 'https://github.com/theskyboxcompany/OneFlow.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5'
  s.source_files = 'OneFlow/Classes/**/*'
  
   #s.resource_bundles = {
   #  'OneFlow' => ['OneFlow/Assets/**/*']
   #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'OpenSSL-Universal', '1.1.180'
end
