//
//  DetailViewControllerCategory.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "DetailViewControllerCategoryiPhone.h"
#import "sqlite3.h"


@implementation DetailViewControllerCategoryiPhone

@synthesize detailTextView = _detailTextView;
@synthesize imageView;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
#pragma mark - Managing the detail item


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    def = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self configureView];
    }
    
    if (BusName == nil)
    {
        self.detailTextView.text = @"Please file a bug report from the AppStore if you see this error.";
    }
    else 
    {
        self.detailTextView.text = BusName;
    }
    
    if (BusImg == nil)
    {
        self.imageView.image = nil;  
    }
    else
    {
        NSURL *BusImgURL = [[NSURL alloc] initWithString:BusImg];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:BusImgURL];
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        self.imageView.image = img;
    }    
}
- (void)configureView
{
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"GLENNSDB.sqlite"];
    const char *dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TBL_BUSINESS_DETAIL WHERE BUS_NAME = '%@';", [def objectForKey:@"CatChoiceDetail"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                BusName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                BusImg = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                
            } 
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(db);
    }
}


- (void)viewDidUnload
{
    [self setImageView:nil];
 [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
