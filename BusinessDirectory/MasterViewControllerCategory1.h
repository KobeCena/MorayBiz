//
//  MasterViewControllerCategory1.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 13/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class MasterViewControllerCategory;
@class DetailViewControllerCategory;

@interface MasterViewControllerCategory1 : UITableViewController
{
    sqlite3 *db;
    NSUserDefaults *def;
    NSMutableSet *ApproSet;
    NSMutableArray *arrayAppro;
    NSArray *sortedArray;
}

@property (strong, nonatomic) DetailViewControllerCategory *detailViewController;

- (void)initializeBusData;

@end
