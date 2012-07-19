//
//  TestViewController.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 03/05/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController
@synthesize scrollView;
@synthesize button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)download:(id)sender {
    NSString *stringURL = @"http://gizmoloon.com/busdirdb/BUSDIR.sqlite";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];  
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];
        [urlData writeToFile:filePath atomically:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [scrollView setContentSize:(CGSizeMake(800, 1000))];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
