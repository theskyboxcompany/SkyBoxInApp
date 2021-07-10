#
# Be sure to run `pod lib lint OneFlow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OneFlow'
  s.version          = '1.0.5'
  s.summary          = 'OneFlow Framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'OneFlow Framework Purchase, Survey'

  s.homepage         = 'https://github.com/theskyboxcompany/OneFlow'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rohantryskybox' => 'rohan@tryskybox.com' }
  s.source           = { :git => 'https://github.com/theskyboxcompany/OneFlow.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5'
  s.source_files = 'OneFlow/Classes/**/*'
  
#   s.resource_bundles = {
#     'OneFlow' => ['OneFlow/Assets/**/*']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.subspec 'Survey' do |survey|
       survey.source_files = 'Survey/Classes/**/*'
       survey.resources = 'Survey/Assets/**/*'
     end
   s.subspec 'Purchase' do |purchase|
       purchase.source_files = 'Purchase/Classes/**/*'
#       purchase.resources = 'Purchase/Assets/**/*'
       purchase.dependency 'OpenSSL-Universal', '1.1.180'
     end
end
