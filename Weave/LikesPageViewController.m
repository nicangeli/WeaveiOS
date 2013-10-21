//
//  LikesPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "LikesPageViewController.h"
#import "AppDelegate.h"
#import "ImageDownloader.h"
#import "ProductDetailViewController.h"

@interface LikesPageViewController ()

@end

@implementation LikesPageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    [[Mixpanel sharedInstance] track:@"Likes page loaded"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry endTimedEvent:@"Products_Viewed" withParameters:nil]; // You can pass in additiona

    
    Likes *likes = [Likes instance];
    NSString *count = [NSString stringWithFormat:@"%d", [likes count]];
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Num_Likes", count, // Capture author info
     nil];
    
    [Flurry logEvent:@"Likes_Viewed" withParameters:articleParams];
}


-(IBAction)handleTap:(UITapGestureRecognizer *)recognizer
{
    Likes *l = [Likes instance];
    NSMutableArray *likes = [l getLikes];
    CGPoint point = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    int index  = [likes count] - indexPath.row -1;

    Product *p = [likes objectAtIndex:index];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ProductDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    viewController.product = p;
    [self.navigationController pushViewController:viewController animated:YES];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"num of rows called now");
    Likes *likes = [Likes instance];
    // Return the number of rows in the section.
    //NSLog(@"items num %d", [likes count]);
    
    return [likes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Likes *likes = [Likes instance];
    static NSString *CellIdentifier = @"ProductCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int index  = [likes count] - indexPath.row -1;
    Product *p = [likes objectAtIndex:index];
    UIImageView *thumbnailView = (UIImageView *)[cell viewWithTag:100];
    //thumbnailView.image = [UIImage imageNamed:[p getImageUrl]];
    //thumbnailView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [p getImageUrl]]]];
    thumbnailView.image = [UIImage imageWithContentsOfFile:[p getImageUrl]];
    thumbnailView.contentMode = UIViewContentModeScaleAspectFit;

    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    titleLabel.text = [p getTitle];
        
    UILabel *brandLabel = (UILabel *)[cell viewWithTag:103];
    brandLabel.text = [p getBrand];
    
    UILabel *priceLavel = (UILabel *)[cell viewWithTag:104];
    priceLavel.text = [p getPrice];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Likes *likes = [Likes instance];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Product *p = [likes objectAtIndex:indexPath.row];
        [likes removeProductAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [ImageDownloader deleteFileAtPath:[p getImageUrl]];
        [self saveLikes];
    }

}

-(void)saveLikes
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    /* get likes from appdelegate */
    Likes *likes = [Likes instance];
    [archiver encodeObject:likes forKey:@"Likes"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Weave.plist"];
}

@end
