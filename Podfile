source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.3'
use_frameworks!

target 'BeautyFinder' do
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
pod 'Kingfisher', '~> 2.6.0'
pod 'CVCalendar', '1.3.1'
pod 'IQKeyboardManagerSwift', '4.0.5'
pod 'MarqueeLabel/Swift', :git => "https://github.com/cbpowell/MarqueeLabel.git", :branch => "swift-2.3"
pod 'SWXMLHash', '~> 2.1.0'
pod 'SwiftSpinner', '~> 0.9.0'
pod 'PureLayout'
pod 'Datez', '1.0.0'
pod 'SwiftyJSON', '2.3.2'
end

target 'BeautyFinderTests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
