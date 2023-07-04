import UIKit
import Social
import MobileCoreServices

@objc(ShareViewController)
class ShareViewController: SLComposeServiceViewController {
    let hostAppURLScheme = "SCHEMA"
    let textImageType = kUTTypeImage as String

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    override func didSelectPost() {
      if let content = self.extensionContext!.inputItems[0] as? NSExtensionItem {
        if let contents = content.attachments {
          for (_, attachment) in (contents).enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(self.textImageType) {
                attachment.loadItem(forTypeIdentifier: self.textImageType, options: nil) { data, error in
                    let imageUrl = data as NSURL;
                    let sharedImageUrl = self.saveImage(url: imageUrl)
                    self.redirectToHostApp(sharedURL: sharedImageUrl)
                    extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
          }
        }
      }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    func saveImage(url: NSURL) -> String {
        guard let imageData = NSData(contentsOfURL: url) else { return }
        let selectedImage = UIImage(data: imageData)

        let fileManager = NSFileManager.defaultManager()
        if let sharedContainer = fileManager.containerURLForSecurityApplicationGroupIdentifier("APP_GROUPS") {
            if let dirPath = sharedContainer.path {
                let sharedImageFilePath = dirPath + "/image.png"
                let binaryImageData = UIImagePNGRepresentation(selectedImage!)
                binaryImageData?.writeToFile(sharedImageFilePath, atomically: true)
                // send the sharedImageFilePath to the containing app
                return sharedImageFilePath;
            }
        }

        return "";
    }
  
    private func redirectToHostApp(sharedURL: String) {
          var urlComponents = URLComponents()
          urlComponents.scheme = hostAppURLScheme
          urlComponents.host = "share"
          urlComponents.path = "/"
          urlComponents.queryItems = [
              URLQueryItem(name: "url", value: sharedURL),
          ]
          // urlComponents.url: \(scheme)://share/?url=\(sharedURL)
          let url = urlComponents.url
          var responder = self as UIResponder?
          let selectorOpenURL = sel_registerName("openURL:")
          
          while (responder != nil) {
              if (responder?.responds(to: selectorOpenURL))! {
                  responder?.perform(selectorOpenURL, with: url)
              }
              responder = responder!.next
          }
      }
}
