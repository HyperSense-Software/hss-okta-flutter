import Flutter
import WebAuthenticationUI

class WebSignOutNativeViewFactory: NSObject, FlutterPlatformViewFactory {
            private var messenger: FlutterBinaryMessenger
            public static var platformViewName = "dev.hypersense.software.hss_okta.views.browser.signout"
            
            init(messenger: FlutterBinaryMessenger) {
                self.messenger = messenger
                super.init()
            }
            
            func create(
                withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?
            ) -> FlutterPlatformView {
                return WebSignOutNativeView(
                    frame: frame,
                    viewIdentifier: viewId,
                    arguments: args,
                    binaryMessenger: self.messenger
                )
            }
            
            
            public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
                return FlutterStandardMessageCodec.sharedInstance()
            }
        }
        
        class WebSignOutNativeView: NSObject, FlutterPlatformView {
            private var _view: UIView
            
            
            init(
                frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?,
                binaryMessenger messenger: FlutterBinaryMessenger) {
                    _view = UIView()
                    super.init()
                    
                    let browserAuth = FlutterEventChannel(name: "dev.hypersense.software.hss_okta.channels.browser_signout", binaryMessenger: messenger)
                    
                    browserAuth.setStreamHandler(BrowserSignOutHandler(view: _view))
                    createNativeView(view: _view)
                }
            
            func view() -> UIView {
                
                return _view
            }
            
            
            func createNativeView(view _view: UIView){}
        }
        
        class BrowserSignOutHandler : NSObject, FlutterStreamHandler{
            private var sink: FlutterEventSink?
            lazy var auth = WebAuthentication.shared
            private var view : UIView
            
            init(view : UIView){
                self.view = view
                super.init()
            }
            
            func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
                
                self.sink = eventSink
                Task{@MainActor in
                    
                    if(auth == nil){
                        eventSink(FlutterError(code: "ConfigError", message: "Missing or bad Okta.plist", details: ""))
                        return;
                    }
                    
                    self.auth?.signOut(from:self.view.window,completion:{
                        result in
                        switch result{
                        case .success():
                            eventSink(true)
                            
                        case .failure(let error):
                            eventSink(FlutterError(code: "Browser Sign out Failed", message: error.localizedDescription.stringValue, details: ""))
                            break;
                            
                        default :
                            break;
                        }
                    })
                    
                }
                
                return nil
                
            }
            
            func onCancel(withArguments arguments: Any?) -> FlutterError? {
                sink = nil
                return nil
            }
            
            
        }
    
