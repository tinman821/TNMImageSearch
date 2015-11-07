//
//  SearchResult.h
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageResult : NSObject

@property (nonatomic) NSURL *thumbnailURL;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;

- (instancetype)initWithJSONObject:(id)jsonObject;

@end

@interface SearchResult : NSObject

@property (nonatomic) NSArray<ImageResult *> *imageResults;

- (instancetype)initWithJSONObject:(id)jsonObject;

@end

NS_ASSUME_NONNULL_END
