//
//  ImageSearchError.h
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/6/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ImageSearchErrorDomain;

typedef NS_ENUM(NSInteger, ImageSearchErrorCode) {
    ImageSearchErrorCodeJSONError,
    ImageSearchErrorCodeImageError,
    ImageSearchErrorCodeNetworkError,
    ImageSearchErrorCodeServerError
};

@interface ImageSearchError : NSObject

+ (void)presentErrorOnViewController:(UIViewController *)controller
                               error:(NSError *)imageSearchError;

@end