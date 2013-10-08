//
//  BrandsViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 07/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "BrandsViewController.h"

@interface BrandsViewController ()

@end

@implementation BrandsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.topshopClicked = NO;
        self.asosClicked = NO;
        self.hmClicked = NO;
        self.newlookClicked = NO;
        self.otherStoriesClicked = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults stringArrayForKey:@"brands"] count] != 0) {
        NSArray *brands = [defaults stringArrayForKey:@"brands"];
        NSLog(@"Seen some brands before: %@", brands);
        for(NSString *brand in brands) {
            NSLog(@"brand: %@", brand);
            if([brand isEqualToString:@"Topshop"]) {
                [self topshopClicked:nil];
            }
            if([brand isEqualToString:@"ASOS"]) {
                [self asosClicked:nil];
            }
            if([brand isEqualToString:@"H&M"]) {
                [self hmClicked:nil];
            }
            if([brand isEqualToString:@"New Look"]) {
                [self newlookClicked:nil];
            }
            if([brand isEqualToString:@"& other Stories"]) {
                [self otherStoriesClicked:nil];
            }
        }
    } else {
        NSLog(@"Count is zero");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)topshopClicked:(id)sender
{
    self.topshopClicked = !self.topshopClicked;
    UIButton *image = (UIButton *)[self.view viewWithTag:401];

    if(self.topshopClicked) {
        [image setImage:[UIImage imageNamed:@"topshop-clicked.png"] forState:UIControlStateNormal];
    } else {
        [image setImage:[UIImage imageNamed:@"topshop"] forState:UIControlStateNormal];
    }
    [self updateBrands];
}

-(IBAction)asosClicked:(id)sender
{
    self.asosClicked = !self.asosClicked;
    UIButton *image = (UIButton *)[self.view viewWithTag:402];
    if(self.asosClicked) {
        [image setImage:[UIImage imageNamed:@"asos-clicked.png"] forState:UIControlStateNormal];
    } else {
        [image setImage:[UIImage imageNamed:@"asos.png"] forState:UIControlStateNormal];
    }
    [self updateBrands];

}

-(IBAction)hmClicked:(id)sender
{
    self.hmClicked = !self.hmClicked;
    UIButton *image = (UIButton *)[self.view viewWithTag:403];
    if(self.hmClicked) {
        [image setImage:[UIImage imageNamed:@"h&m-clicked.png"] forState:UIControlStateNormal];
    } else {
        [image setImage:[UIImage imageNamed:@"h&m.png"] forState:UIControlStateNormal];
    }
    [self updateBrands];

}

-(IBAction)newlookClicked:(id)sender
{
    self.newlookClicked = !self.newlookClicked;
    UIButton *image = (UIButton *)[self.view viewWithTag:404];
    if(self.newlookClicked) {
        [image setImage:[UIImage imageNamed:@"newlook-clicked.png"] forState:UIControlStateNormal];
    } else {
        [image setImage:[UIImage imageNamed:@"newlook.png"] forState:UIControlStateNormal];
    }
    [self updateBrands];

}

-(IBAction)otherStoriesClicked:(id)sender
{
    self.otherStoriesClicked = !self.otherStoriesClicked;
    UIButton *image = (UIButton *)[self.view viewWithTag:405];
    if(self.otherStoriesClicked) {
        [image setImage:[UIImage imageNamed:@"otherstories-clicked.png"] forState:UIControlStateNormal];
    } else {
        [image setImage:[UIImage imageNamed:@"otherstories.png"] forState:UIControlStateNormal];
    }
    [self updateBrands];

}

-(void)updateBrands
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *brands = [[NSMutableArray alloc] initWithCapacity:5];
        if(self.topshopClicked) {
            [brands addObject:@"Topshop"];
        }
        if(self.asosClicked) {
            [brands addObject:@"ASOS"];
        }
        if(self.hmClicked) {
            [brands addObject:@"H&M"];
        }
        if(self.newlookClicked){
            [brands addObject:@"New Look"];
        }
        if(self.otherStoriesClicked) {
            [brands addObject:@"@ other Stories"];
        }
        [defaults setObject:brands forKey:@"brands"];
}


@end
