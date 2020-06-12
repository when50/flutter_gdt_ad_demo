//
//  FlutterIosTextLabelRegistran.swift
//  Runner
//
//  Created by oneko on 2020/6/12.
//

import UIKit

class FlutterIosTextLabel: NSObject, FlutterPlatformView, GDTUnifiedNativeAdDelegate, GDTUnifiedNativeAdViewDelegate {
    var label: UILabel
    var myView: UIView
    let identifier: Int64
    var channel: FlutterMethodChannel!
    
    var adLoader: GDTUnifiedNativeAd?
    var adView: UnifiedNativeAdCustomView
    
    init(frame: CGRect, identifier: Int64, arguments: Any?, binaryMessenger: FlutterBinaryMessenger) {
        
        label = UILabel(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 414, height: 22))
        label.textColor = .red
        label.text = "ios原生label"
        label.backgroundColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        
        myView = UIView(frame: CGRect(x: frame.origin.x, y:frame.origin.y, width: 414, height: 80))
        myView.addSubview(label)
        
        let btn = UIButton(type: .custom)
        btn.setTitle("点击", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.frame = CGRect(x: 50, y: 30, width: 80, height: 40)
        myView.addSubview(btn)
        
        adView = UnifiedNativeAdCustomView()
        
        self.identifier = identifier
        
        self.channel = FlutterMethodChannel(name: "", binaryMessenger: binaryMessenger)
        super.init()
        btn.addTarget(self, action: #selector(btnAction(sener:)), for: UIControl.Event.touchUpInside)
        
        loadAD()
    }
    
    func loadAD() {
        if adLoader == nil {
            adLoader = GDTUnifiedNativeAd(appId: "1105344611", placementId: "2000566593234845")
            adLoader?.delegate = self
            adLoader?.loadAd(withAdCount: 10)
        }
    }
    
    func setupWithUnifiedNativeAdDataObject(dataObject: GDTUnifiedNativeAdDataObject, delegate: GDTUnifiedNativeAdViewDelegate/*, vc: UIViewController*/) {
        self.adView.delegate = delegate
        self.adView.viewController = UIApplication.shared.keyWindow?.rootViewController
        var imageRate:CGFloat = 16 / 9
        if dataObject.imageHeight > 0 {
            imageRate = CGFloat(dataObject.imageWidth / dataObject.imageHeight)
        }
        let width = UIScreen.main.bounds.width - 16
        self.adView.backgroundColor = UIColor.gray
        self.adView.iconImageView.frame = CGRect(x: 8, y: 8, width: 60, height: 60);
        self.adView.clickButton.frame = CGRect(x: width - 68, y: 8, width: 60, height: 44);
        self.adView.CTAButton.frame = CGRect(x: width - 100, y: 8, width: 100, height: 44);
        self.adView.titleLabel.frame = CGRect(x: 76, y: 8, width: 250, height: 30);
        self.adView.descLabel.frame = CGRect(x: 8, y: 76, width: width, height: 30);
        let imageWidth:CGFloat = width
        self.adView.imageView.frame = CGRect(x: 8, y: 114, width: imageWidth, height: imageWidth / imageRate)
        self.adView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 122 + imageWidth / imageRate)
        self.adView.logoView.frame = CGRect(x: self.adView.frame.width - kGDTLogoImageViewDefaultWidth, y: self.adView.frame.height - kGDTLogoImageViewDefaultHeight, width: kGDTLogoImageViewDefaultWidth, height: kGDTLogoImageViewDefaultHeight)
        self.adView.setupWithUnifiedNativeAdObject(unifiedNativeDataObject: dataObject)
        self.adView.registerDataObject(dataObject, clickableViews: [self.adView.clickButton,self.adView.iconImageView,self.adView.imageView])
        if let newDataObject = dataObject.callToAction {
            if newDataObject.count > 0 {
                self.adView.registerClickableCall(toActionView: self.adView.CTAButton)
            }
        }
    }
    
    @objc
    func btnAction(sener: UIButton) {
        myView.backgroundColor = .yellow
    }
    
    func view() -> UIView {
        return adView;
    }
    
    // MARK: -gdt ad delegate
    
    func gdt_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [GDTUnifiedNativeAdDataObject]?, error: Error?) {
        if (unifiedNativeAdDataObjects?.count ?? 0) > 0 {
            self.setupWithUnifiedNativeAdDataObject(dataObject: unifiedNativeAdDataObjects![0], delegate: self)
        }
    }
}

class FlutterIosTextLabelFactory: NSObject, FlutterPlatformViewFactory {
    private weak var _messenger: FlutterBinaryMessenger?
    init(messager: FlutterBinaryMessenger) {
        _messenger = messager
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let label = FlutterIosTextLabel(frame: frame, identifier: viewId, arguments: args, binaryMessenger: _messenger!)
        return label
    }
}

class FlutterIosTextLabelPlugin : NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(FlutterIosTextLabelFactory(messager:registrar.messenger()), withId: "com.flutter_to_native_test_textview")
    }
}

class FlutterIosTextLabelRegistran: NSObject {
    static func registerWithRegistry(registry: FlutterPluginRegistry) {
        FlutterIosTextLabelPlugin.register(with: registry.registrar(forPlugin: "FlutterIosTextLabelPlugin"))
    }
}
