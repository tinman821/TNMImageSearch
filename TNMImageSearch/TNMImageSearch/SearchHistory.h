//
//  SearchHistory.h
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistory : NSObject

- (void)clearHistory;
- (void)addTermToHistory:(NSString *)searchTerm;

- (NSArray<NSString *> *)historyForSearchTerm:(NSString *)searchTerm;
- (NSArray<NSString *> *)allHistory;
- (void)removeTermAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END