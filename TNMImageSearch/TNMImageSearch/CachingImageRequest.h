//
//  CachingImageRequest.h
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ImageRequestCompletionBlock)(UIImage * _Nullable image, float completionPercentage, NSError *_Nullable error);

@interface CachingImageRequest : NSObject

- (instancetype)initWithImageURL:(NSURL *)imageURL;

- (void)performRequestWithCompletion:(ImageRequestCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END