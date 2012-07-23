//
//  MasterViewControllerTown.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 09/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class DetailViewControllerName;

@interface MasterViewControllerName : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSArray *businesses;
    NSMutableArray *alphabet;
    UITableViewCell *cell;
    NSMutableArray *arrayTown;
    sqlite3 *db;
    NSMutableSet *TownSet;
    NSArray *sortedArray;
    NSUserDefaults *def;
    __weak IBOutlet UISearchBar *searchBar;
    NSArray *filteredData;
    UISearchDisplayController *searchDis;
}

@property (strong, nonatomic) DetailViewControllerName *detailViewController;

@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)initializeBusData;

@end