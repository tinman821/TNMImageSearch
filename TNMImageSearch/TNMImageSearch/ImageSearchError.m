//
//  ImageSearchError.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/6/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "ImageSearchError.h"

NSString * const ImageSearchErrorDomain = @"com.tinman821.ImageSearchErrorDomain";

@implementation ImageSearchError

+ (void)presentErrorOnViewController:(UIViewController *)controller
                               error:(NSError *)imageSearchError {
    NSString *message = nil;

    switch ((ImageSearchErrorCode)imageSearchError.code) {
        case ImageSearchErrorCodeImageError:
            message = [NSString stringWithFormat:NSLocalizedString(@"Failed to load image: %@", nil), [imageSearchError.userInfo[NSUnderlyingErrorKey] localizedDescription]];
            break;
        case ImageSearchErrorCodeJSONError:
            message = [NSString stringWithFormat:NSLocalizedString(@"Failed to read server response: %@", nil), [imageSearchError.userInfo[NSUnderlyingErrorKey] localizedDescription]];
            break;
        case ImageSearchErrorCodeNetworkError:
            message = [NSString stringWithFormat:NSLocalizedString(@"There was a network error: %@", nil), [imageSearchError.userInfo[NSUnderlyingErrorKey] localizedDescription]];
            break;
        case ImageSearchErrorCodeServerError:
            message = [NSString stringWithFormat:NSLocalizedString(@"There was a server error: %@", nil), [imageSearchError localizedDescription]];
            break;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alertController addAction:action];
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end