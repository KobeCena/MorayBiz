//
//  MapsWebViewController.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 03/07/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapsWebViewControllerName : UIViewController <UIWebViewDelegate>
{
    UIWebView *mapsView;
    NSUserDefaults *def;
    UIActivityIndicatorView *active;
    NSString *fullBusAddr;
    NSString *googleCall;
    NSString *fixedAddr;
    NSString *googleAddr;
    NSURL *googleURL;
}

@end
