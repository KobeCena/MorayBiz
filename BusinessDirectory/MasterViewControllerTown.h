//
//  MasterViewControllerTown.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 09/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class DetailViewControllerTown;

@interface MasterViewControllerTown : UITableViewController
{
    UITableViewCell *cell;
    NSMutableArray *arrayTown;
    sqlite3 *db;
    NSMutableSet *TownSet;
    NSArray *sortedArray;
    NSUserDefaults *def;
}

@property (strong, nonatomic) DetailViewControllerTown *detailViewController;

- (void)initializeBusData;

@end