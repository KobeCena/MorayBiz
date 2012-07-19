//
//  MapsWebViewController.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 03/07/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "MapsWebViewControllerName.h"

@interface MapsWebViewControllerName ()

@end

@implementation MapsWebViewControllerName

- (void)loadView
{
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(160, 240, 50, 50);
    
    mapsView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
    [mapsView setDelegate:self];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Google Maps"];
    UIBarButtonItem *bbDismiss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalViewControllerAnimated:)];
    active = [[UIActivityIndicatorView alloc] init];
    active.hidesWhenStopped = YES;
    [active setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [active setFrame:CGRectMake(289, 12, 20, 20)];
    
    [navBar addSubview:active];
    [navBar pushNavigationItem:navItem animated:YES];
    [navItem setLeftBarButtonItem:bbDismiss];
    
    [mainView addSubview:button];
    [mainView addSubview:navBar];
    [mainView addSubview:mapsView];
    
    mainView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.view = mainView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [active startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [active stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:[def objectForKey:@"finalStringName"] message:@"HAPPY?" delegate:self cancelButtonTitle:@"dismiss" otherButtonTitles:nil];
    [al show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    def = [NSUserDefaults standardUserDefaults];
    NSURL *finalURL = [NSURL URLWithString:[def objectForKey:@"finalStringName"]];
    [mapsView loadRequest:[NSURLRequest requestWithURL:finalURL]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
