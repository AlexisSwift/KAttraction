platform :ios, '17.0'

use_frameworks!
inhibit_all_warnings!

def common_pods
  pod 'SnapKit'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'RxRelay'
  pod 'R.swift'
  pod 'Alamofire'
  pod 'Kingfisher'
end

target 'KAttraction' do
  common_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
    end
  end
end
