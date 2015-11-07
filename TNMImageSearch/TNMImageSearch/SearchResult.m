//
//  SearchResult.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "SearchResult.h"

@implementation ImageResult

- (instancetype)initWithJSONObject:(id)jsonObject {
    if (self = [super init]) {
        self.thumbnailURL = [NSURL URLWithString:jsonObject[@"tbUrl"]];
        self.imageURL = [NSURL URLWithString:jsonObject[@"url"]];
        self.title = jsonObject[@"titleNoFormatting"];
    }
    return self;
}

@end

@implementation SearchResult

- (instancetype)initWithJSONObject:(id)jsonObject {
    if (self = [super init]) {
        if ([jsonObject[@"responseStatus"] integerValue] == 200) {
            NSArray *results = jsonObject[@"responseData"][@"results"];
            NSMutableArray *imageResults = [NSMutableArray new];
            for (id result in results) {
                ImageResult *imageResult = [[ImageResult alloc] initWithJSONObject:result];
                [imageResults addObject:imageResult];
            }
            self.imageResults = imageResults;
        }
    }
    return self;
}

@end