//
//  SplashViewController.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 10/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController
{
    UIAlertView *lol;
    __weak IBOutlet UIButton *advance;
    __weak IBOutlet UIButton *download;
}
@property (weak, nonatomic) IBOutlet UILabel *DetailText;

@end
