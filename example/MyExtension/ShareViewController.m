//
//  ShareViewController.m
//  Ez File Transfer Pro Share
//
//  Created by ezerway on 30/06/2023.
//

#import "ShareViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    if ([self.extensionContext inputItems].count < 1) {
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        return;
    }
    
    NSExtensionItem *content = [[self.extensionContext inputItems] firstObject];
    NSArray<NSItemProvider *> *contents = [content attachments];
    
    for (NSItemProvider *attachment in contents) {
        if ([attachment hasItemConformingToTypeIdentifier: (NSString *) kUTTypeImage] != NO) {
            [attachment loadItemForTypeIdentifier:(NSString *) kUTTypeImage options: nil completionHandler:^(__kindof id<NSSecureCoding>  _Nullable data, NSError * _Null_unspecified error) {
                NSURL *imageUrl = (NSURL *) data;
                NSString *sharedImageUrl = [self saveImage:imageUrl];
                [self redirectToHostApp: sharedImageUrl];
                [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
            }];
        }
    }
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

- (NSString *) saveImage: (NSURL *) url {
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *selectedImage = [UIImage imageWithData:imageData];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *sharedContainer = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"APP_GROUPS"];
    NSString *dirPath = sharedContainer.path;
    NSString *sharedImageFilePath = [NSString stringWithFormat:@"%@/%@", dirPath, @"image.png"];
    NSData *binaryImageData = UIImagePNGRepresentation(selectedImage);
    [binaryImageData writeToFile:sharedImageFilePath atomically:YES];
    return sharedImageFilePath;
}

- (void) redirectToHostApp: (NSString *) sharedUrl {
    NSString *appURL = [NSString stringWithFormat:@"SCHEMA://share?url=%@", sharedUrl];
    SEL selectorOpenURL = sel_registerName("openURL:");
    UIResponder *responder = (UIResponder *) self;
    
    while (responder != nil) {
        if ([responder respondsToSelector:(selectorOpenURL)] != FALSE) {
            [responder performSelector:(selectorOpenURL) withObject: [NSURL URLWithString: appURL]];
        }
        responder = responder.nextResponder;
    }
}

@end
