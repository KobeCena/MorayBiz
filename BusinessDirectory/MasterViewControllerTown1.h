//
//  MasterViewControllerTown1.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 13/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class DetailViewControllerTown;

@interface MasterViewControllerTown1 : UITableViewController <UITableViewDelegate>
{
    NSMutableArray *arrayAppro;
    sqlite3 *db;
    NSUserDefaults *def;
    NSMutableSet *ApproSet;
    NSArray *sortedArray;
}

@property (strong, nonatomic) NSMutableArray *arrayAppro;
@property (strong, nonatomic) DetailViewControllerTown *detailViewController;
- (void)initializeBusData;

@end
