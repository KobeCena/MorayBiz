//
//  AdminEditTableViewController.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 17/05/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface AdminEditTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *testArray;
    sqlite3 *db;
    UITableViewCell *cell;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
