//
//  AdminLoginViewController.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 17/05/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "AdminLoginViewController.h"

@interface AdminLoginViewController ()

@end

@implementation AdminLoginViewController
@synthesize textField;
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (IBAction)loginProcess:(id)sender {
    if (textField.text == nil)
    {
        UIAlertView *lol = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"The password entered was incorrect. Please check spelling and punctuation and try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [lol show];
    }
    else
    {
        [self performSegueWithIdentifier:@"Login" sender:self];   
    }
    
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
