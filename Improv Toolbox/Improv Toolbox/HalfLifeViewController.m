//
//  HalfLifeViewController.m
//  Improv Toolbox
//
//  Created by Sydney Richardson on 11/20/14.
//  Copyright (c) 2014 Gainesville Improv Festival. All rights reserved.
//

#import "HalfLifeViewController.h"
#import <iAd/iAd.h>
#import <AVFoundation/AVFoundation.h>

@interface HalfLifeViewController () <AVAudioPlayerDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)startTimer:(id)sender;
- (IBAction)halfTimer:(id)sender;
- (IBAction)resetButton:(id)sender;

@property (strong, nonatomic) NSTimer *timer;
@property int timerValue;
@property int timerCursor;
@property (strong, nonatomic) NSArray *timerValues;

@property (weak, nonatomic) IBOutlet ADBannerView *adView;

@property AVAudioPlayer *player;

@end

@implementation HalfLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timerValues = @[ @600, @300, @150, @75, @30, @15];
    self.timerCursor = 0;
    [self updateTimerValue];
    
    //set up the iAd, make this the delegate
    self.adView.delegate = self;
    // Initially hide the ad banner.
    self.adView.alpha = 0.0;
    
    //initilize the AudioPlayer
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"buzzer" ofType:@"mp3"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [self.player setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About"
                                                                                                   style:UIBarButtonItemStylePlain
                                                                                                  target:self
                                                                                                  action:@selector(aboutHalfLife:)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //remove the About button
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTimer:(id)sender {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(updateTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (IBAction)halfTimer:(id)sender {
    // stop the timer
    [self killTimer];
    
    // increment the cursor
    [self incrementTimerCursor];
    
    [self updateTimer];
}

- (void) incrementTimerCursor {
    self.timerCursor = (self.timerCursor + 1) % [self.timerValues count];

}

- (void) updateTimer {
    // updates the timer value and the timer label ui
    // because these should be done at the same timer
    // don't want one updated without the other
    [self updateTimerValue];
    [self updateTimerLabel];
}

- (IBAction)resetButton:(id)sender {
    [self resetTimer];
    
    // update the timer
    [self updateTimer];
}

- (void)aboutHalfLife:(id)sender {
    // display a help alert dialog box
    UIAlertView *aboutHalfLife = [[UIAlertView alloc] initWithTitle:@"How to play Half Life"
                                                            message:@"Players act out a scene for a minute. When the timer ends, act out the SAME SCENE again, in half the time. \nContinue this until the players act out the scene in 1.5 seconds, then take down the scene."
                                                           delegate:self
                                                  cancelButtonTitle:@"Got it"
                                                  otherButtonTitles:nil];
    
    [aboutHalfLife show];
}

- (void)updateTimer:(id)sender {
    // if the timer is going
    if (self.timer) {
        // decrement the timer value
        self.timerValue--;
        //update the ui label
        [self updateTimerLabel];
        
        if(self.timerValue == 0){
            //it hit zero, so sound an alert and stop the thing
            [self playEndOfTimerSound];
            
            // check if need to show the "Take it down" alert
            [self displayTakeItDownQuestionMark];
            
            //increment the timer cursor
            [self incrementTimerCursor];
            
            //stop the timer
            [self killTimer];
            
            //update the timer value
            [self updateTimer];
        }
    }
}

- (void)killTimer{
    if(self.timer){
        // sets the timer to nil
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateTimerLabel {
    int decimal = self.timerValue/10;
    [self.timeLabel setText:[NSString stringWithFormat:@"%d.%d", decimal, self.timerValue-decimal*10]];
}

- (void)updateTimerValue {
    self.timerValue = [[self.timerValues objectAtIndex:self.timerCursor] intValue];
}

- (void)resetTimerValue
{
    self.timerCursor = 0;
}

- (void)resetTimer
{
    // stop the timer
    [self killTimer];
    
    //set the cursor to be 0
    [self resetTimerValue];
}

- (void)displayTakeItDownQuestionMark
{
    if (self.timerCursor == ([self.timerValues count] - 1)) {
        // display the take it down alert
        UIAlertView *takeItDown = [[UIAlertView alloc] initWithTitle:@"Take it Down!"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Yep"
                                                      otherButtonTitles:nil];
        
        [takeItDown show];
    }
}

#pragma mark - iAd methods
// if I wanted to be more OO, should put these in a separate class for one point of access instead of copy pasta'ing

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    // Show the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        self.adView.alpha = 1.0;
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Unable to show ads. Error: %@", [error localizedDescription]);
    
    // failed to find an advertisement to display
    // hide the banner
    [UIView animateWithDuration:0.5 animations:^{
        self.adView.alpha = 0.0;
    }];
}

#pragma mark - Audio Player methods

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //required by AudioPlayerDelegate to have this method
}

- (void)playEndOfTimerSound {
    [self.player play];
}

@end
