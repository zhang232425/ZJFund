#
# Be sure to run `pod lib lint ZJFund.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
  s.name             = 'ZJFund'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ZJFund.'
  s.homepage         = 'https://github.com/zhang232425/ZJFund.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '51930184@qq.com' => 'yonathan@asetku.com' }
  s.source           = { :git => 'https://github.com/zhang232425/ZJFund.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'

  s.source_files = 'ZJFund/Classes/**/*'
  s.resource_bundles = {
      'ZJFund' => ['ZJFund/Assets/**/*']
  }
  s.static_framework = true
  
  s.dependency 'Then'
  s.dependency 'SnapKit'
  s.dependency 'Action'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift'
  s.dependency 'RxDataSources'
  s.dependency 'RxSwiftExt'
  
  s.dependency 'SwiftDate'
  s.dependency 'SideMenu'
  s.dependency 'AAInfographics'
  s.dependency 'Charts'
  s.dependency 'FMDB'
  s.dependency 'ReachabilitySwift'
  s.dependency 'ObjectMapper'
  s.dependency 'Alamofire'
  
  s.dependency 'ZJRequest'
  s.dependency 'ZJLocalizable'
  s.dependency 'ZJRouter'
  s.dependency 'ZJRoutableTargets'
  s.dependency 'ZJBase'
  s.dependency 'ZJExtension'
  s.dependency 'ZJHUD'
  s.dependency 'ZJCommonView'
  s.dependency 'ZJRefresh'
  s.dependency 'ZJCommonDefines'
  
end
