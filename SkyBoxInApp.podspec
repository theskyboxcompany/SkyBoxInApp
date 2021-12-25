#
# Be sure to run `pod lib lint SkyBoxInApp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SkyBoxInApp'
  s.version          = '1.0.6'
  s.summary          = 'SkyBoxInApp Framework'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'SkyBoxInApp Framework to hanlde In App Purchases.'

  s.homepage         = 'https://github.com/theskyboxcompany/SkyBoxInApp'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rohantryskybox' => 'rohan@tryskybox.com' }
  s.source           = { :git => 'https://github.com/theskyboxcompany/SkyBoxInApp.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5'
  s.source_files = 'SkyBox/Classes/**/*'
  s.subspec 'Purchase' do |purchase|
       purchase.source_files = 'Purchase/Classes/**/*'
       purchase.dependency 'OpenSSL-Universal', '1.1.180'
     end
end
