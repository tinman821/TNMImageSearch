//
//  SearchRequest.h
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchRequest : NSObject

- (instancetype)initWithSearchTerm:(NSString *)searchTerm startIndex:(NSInteger)startIndex resultSize:(NSInteger)resultSize;

- (void)performRequestWithCompletion:(void (^)(SearchResult *result, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
