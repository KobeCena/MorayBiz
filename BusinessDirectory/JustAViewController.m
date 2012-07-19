//
//  JustAViewController.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 17/07/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "JustAViewController.h"

@interface JustAViewController ()

@end

@implementation JustAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UICollectionViewCell *)collectionViewCell:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    
    
}
- (void)viewDidLoad
{    [super viewDidLoad];
    mainArray = [[NSMutableArray alloc] initWithObjects:@"test", nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidUnload {
    collectionView = nil;
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

@end
