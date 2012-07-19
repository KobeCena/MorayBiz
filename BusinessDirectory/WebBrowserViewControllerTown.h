//
//  MapsWebViewController.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 03/07/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowserViewControllerTown : UIViewController <UIWebViewDelegate>
{
    UIView *mainView;
    UINavigationBar *navBar;
    UIWebView *webView;
    NSUserDefaults *def;
    UIActivityIndicatorView *active;
    NSString *URLString;
    NSURL *stringURL;
}

@end
