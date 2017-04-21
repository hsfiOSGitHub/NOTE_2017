Pod::Spec.new do |s|
  s.name         = "WHC_KeyboardManager"
  s.version      = "1.1.6"
  s.summary      = "iOS平台轻量级的键盘管理器，使用简单功能强大，拒绝全局监控，无入侵性，键盘再也不会挡住输入控件"

  s.homepage     = "https://github.com/netyouli/WHC_KeyboardManager"

  s.license      = "MIT"

  s.author             = { "吴海超(WHC)" => "712641411@qq.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/netyouli/WHC_KeyboardManager.git", :tag => "1.1.6"}

  s.source_files  = "WHC_KeyboradManager/WHC_KeyboradManager/*.{Swift}"

  # s.public_header_files = "Classes/**/*.h"


  s.requires_arc = true


end
