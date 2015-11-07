//
//  SearchHistory.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "SearchHistory.h"

@interface SearchHistory ()

@property (nonatomic) NSMutableArray *searchHistoryInternal;

@end

@implementation SearchHistory

- (instancetype)init {
    if (self = [super init]) {
        [self loadHistoryFromUserDefaults];
        if (!self.searchHistoryInternal) {
            self.searchHistoryInternal = [NSMutableArray new];
        }
    }
    return self;
}

- (void)addTermToHistory:(NSString *)searchTerm {
    [self.searchHistoryInternal insertObject:searchTerm atIndex:0];
    [self saveHistoryToUserDefaults];
}

- (void)clearHistory {
    [self.searchHistoryInternal removeAllObjects];
    [self saveHistoryToUserDefaults];
}

- (void)removeTermAtIndex:(NSInteger)index {
    [self.searchHistoryInternal removeObjectAtIndex:index];
    [self saveHistoryToUserDefaults];
}

- (NSArray *)historyForSearchTerm:(NSString *)searchTerm {
    if (!searchTerm || [searchTerm isEqualToString:@""]) {
        return self.searchHistoryInternal;
    } else {
        return [self.searchHistoryInternal filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchTerm]];
    }
}

- (NSArray *)allHistory {
    return self.searchHistoryInternal;
}

- (void)loadHistoryFromUserDefaults {
    self.searchHistoryInternal = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"]];
}

- (void)saveHistoryToUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryInternal forKey:@"searchHistory"];
}

@end