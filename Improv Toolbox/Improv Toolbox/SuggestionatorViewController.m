//
//  SuggestionatorViewController.m
//  Improv Toolbox
//
//  Created by Sydney Richardson on 11/20/14.
//  Copyright (c) 2014 Gainesville Improv Festival. All rights reserved.
//

#import "SuggestionatorViewController.h"
#import "SuggestionatorHelper.h"
#import <iAd/iAd.h>

@interface SuggestionatorViewController () <ADBannerViewDelegate>

@property (strong, nonatomic) SuggestionatorHelper *helper;
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;
- (IBAction)objectButton:(id)sender;
- (IBAction)relationshipButton:(id)sender;
- (IBAction)locationButton:(id)sender;
- (IBAction)occupationButton:(id)sender;
- (IBAction)eventButton:(id)sender;
- (IBAction)genreButton:(id)sender;
- (IBAction)personButton:(id)sender;
- (IBAction)emotionButton:(id)sender;
- (IBAction)oddballButton:(id)sender;

@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@property (nonatomic, strong) NSTimer *adTimer;
@property (nonatomic) int secondsElapsed;
@property (nonatomic) BOOL pauseTimeCounting;

@end

@implementation SuggestionatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up the iAd, make this the delegate
    self.adView.delegate = self;
    // Initially hide the ad banner.
    self.adView.alpha = 0.0;
    
    // Start the timer for the ads to be changed
    self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(showTimerMessage)
                                                  userInfo:nil
                                                   repeats:YES];
    
    // Set the initial value for the elapsed seconds.
    self.secondsElapsed = 0;

    
    //parse the JSON suggestionator stuff
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"suggestionator" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    self.helper = [[SuggestionatorHelper alloc] init];
    [self.helper parseJsonData:jsonData];
}

#pragma mark - Button Response methods

- (IBAction)objectButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getObject]];
}

- (IBAction)relationshipButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getRelationship]];
}

- (IBAction)locationButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getLocation]];
}

- (IBAction)occupationButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getOccupation]];
}

- (IBAction)eventButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getEvent]];
}

- (IBAction)genreButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getGenre]];
}

- (IBAction)personButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getPerson]];
}

- (IBAction)emotionButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getEmotion]];
}

- (IBAction)oddballButton:(id)sender {
    [self.suggestionLabel setText:[self.helper getOddball]];
}

#pragma mark - iAd methods

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    // Show the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        self.adView.alpha = 1.0;
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    self.pauseTimeCounting = YES;
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {    
    self.pauseTimeCounting = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Unable to show ads. Error: %@", [error localizedDescription]);
    
    // failed to find an advertisement to display
    // hide the banner
    [UIView animateWithDuration:0.5 animations:^{
        self.adView.alpha = 0.0;
    }];
}

- (void)showTimerMessage {
    if (!self.pauseTimeCounting)
        self.secondsElapsed++;
}


@end
