//
//  CollectionModel.h
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionData : NSObject

@property (nonatomic) BOOL loading;
@property (nonatomic) float completionPercentage;
@property (nonatomic, weak, nullable) UIImage *image;     // Weak reference to cached image.
@property (nonatomic) NSURL *thumbnailURL;
@property (nonatomic) NSURL *fullURL;
@property (nonatomic, copy) NSString *title;

@end

@interface CollectionModel : NSObject

@property (nonatomic, readonly) NSArray<CollectionData *> *data;

- (void)addData:(CollectionData *)data;

@end

NS_ASSUME_NONNULL_END