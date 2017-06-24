#
# Be sure to run `pod lib lint LPDQuoteImagesView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LPDQuoteImagesView'
  s.version          = '0.3.1'
  s.summary          = '仿微信qq图片选择器 ImagePicker.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Assuner-Lee/LPDQuoteImagesView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Assuner-Lee' => 'yongguang.li@ele.me' }
  s.source           = { :git => 'https://github.com/Assuner-Lee/LPDQuoteImagesView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LPDQuoteImagesView/Classes/**/*'
  s.resources = 'LPDQuoteImagesView/Assets/LPDImagePickerController.bundle'
  
  # s.resource_bundles = {
  #   'LPDQuoteImagesView' => ['LPDQuoteImagesView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
