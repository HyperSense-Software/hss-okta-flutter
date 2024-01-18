import Flutter
import WebAuthenticationUI

class WebSignInNativeViewFactory: NSObject, FlutterPlatformViewFactory {
            private var messenger: FlutterBinaryMessenger
            public static var platformViewName = "dev.hypersense.software.hss_okta.views.browser.signin"
            
            init(messenger: FlutterBinaryMessenger) {
                self.messenger = messenger
                super.init()
            }
            
            func create(
                withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?
            ) -> FlutterPlatformView {
                return WebSignInNativeView(
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
        
        class WebSignInNativeView: NSObject, FlutterPlatformView {
            private var _view: UIView
            
            
            init(
                frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?,
                binaryMessenger messenger: FlutterBinaryMessenger) {
                    _view = UIView()
                    super.init()
                    
                    let browserAuth = FlutterEventChannel(name: "dev.hypersense.software.hss_okta.channels.browser_signin",
                     binaryMessenger: messenger)
                    browserAuth.setStreamHandler(BrowserAuthenticationHandler(view: _view))
                    createNativeView(view: _view)
                }
            
            func view() -> UIView {
                
                return _view
            }
            
            func createNativeView(view _view: UIView){}
        }
        
class BrowserAuthenticationHandler : NSObject, FlutterStreamHandler{
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
            
            
            self.auth?.signIn(from:self.view.window,completion:{
                result in
                do{
                    
                    switch result{
                    case .success(let token):
                        Credential.default = try Credential.store(token)
                        eventSink(true)
                        
                    case .failure(let error):
                        eventSink(FlutterError(code: "Browser Authentication Failed", message: error.localizedDescription.stringValue, details: "Failed to start Flow"))
                        break;
                        
                    default :
                        break;
                    }
                }catch let error{
                    eventSink(FlutterError(code: "Browser Authentication Failed", message: error.localizedDescription.stringValue, details: "Failed to start Flow"))
                }
            })
            
        }
        return nil;
    }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            sink = nil
            return FlutterError(code: "0", message: "User Cancel", details: "User Canceled the operation")
        }
        
        
    }
    

