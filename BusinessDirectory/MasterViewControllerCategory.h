//
//  MasterViewControllerCategory.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class DetailViewController;

@interface MasterViewControllerCategory : UITableViewController
{
    NSMutableArray *arrayCategory;
    UITableViewCell *cell;
    sqlite3 *db;
    NSUserDefaults *def;
    NSMutableSet *CatSet;
    NSArray *sortedArray;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *arrayCategory;
- (void)initializeBusData;

@end
