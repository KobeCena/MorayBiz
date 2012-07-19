//
//  AppDelegate.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *BusNames;
    sqlite3 *databaseA;
    NSString *busName;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *BusNames;
@property (strong, nonatomic) NSString *busName;
@property (strong, nonatomic) NSArray *getAllUsers;
@end
