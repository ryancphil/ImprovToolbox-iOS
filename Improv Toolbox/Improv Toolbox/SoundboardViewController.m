//
//  SoundboardViewController.m
//  Improv Toolbox
//
//  Created by Sydney Richardson on 11/20/14.
//  Copyright (c) 2014 Gainesville Improv Festival. All rights reserved.
//

#import "SoundboardViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>

@interface SoundboardViewController () <AVAudioPlayerDelegate, ADBannerViewDelegate>

@property AVAudioPlayer *effectPlayer;
@property AVAudioPlayer *beatPlayer;
@property float volume;

- (IBAction)yaySound:(id)sender;
- (IBAction)airhornSound:(id)sender;
- (IBAction)knockSound:(id)sender;
- (IBAction)dingSound:(id)sender;
- (IBAction)buzzerSound:(id)sender;
- (IBAction)countdownSound:(id)sender;
- (IBAction)phone1Sound:(id)sender;
- (IBAction)phone2Sound:(id)sender;
- (IBAction)doorbellSound:(id)sender;
- (IBAction)beat1Sound:(id)sender;
- (IBAction)beat2Sound:(id)sender;
- (IBAction)beat3Sound:(id)sender;

@property (nonatomic) NSMutableArray *beatsPlaying;

@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@property (nonatomic, strong) NSTimer *adTimer;
@property (nonatomic) int secondsElapsed;
@property (nonatomic) BOOL pauseTimeCounting;

@end

@implementation SoundboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    //set up the audio thing
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"airhorn" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:soundPath];
    self.effectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [self.effectPlayer setDelegate:self];
    
    //set up volume for the sounds
    //default 1.0
    self.volume = 1.0;
    
    self.beatsPlaying = [[NSMutableArray alloc] initWithObjects:@NO, @NO, @NO, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // remove the observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didEnterBackground:(id)sender {
    //stop the sound from playing
    [self.effectPlayer stop];
    [self.beatPlayer stop];
    
    //reset what the beats playing are,
    [self resetBeatsPlaying];
}

#pragma mark - Sound playing methods

- (IBAction)yaySound:(id)sender {
    [self playSound:@"yay"];
}

- (IBAction)airhornSound:(id)sender {
    [self playSound:@"airhorn"];
}

- (IBAction)knockSound:(id)sender {
    [self playSound:@"knock"];
}

- (IBAction)dingSound:(id)sender {
    [self playSound:@"ding"];
}

- (IBAction)buzzerSound:(id)sender {
    [self playSound:@"buzzer"];
}

- (IBAction)countdownSound:(id)sender {
    [self playSound:@"countdown"];
}

- (IBAction)phone1Sound:(id)sender {
    [self playSound:@"phone1"];
}

- (IBAction)phone2Sound:(id)sender {
    [self playSound:@"phone2"];
}

- (IBAction)doorbellSound:(id)sender {
    [self playSound:@"doorbell"];
}

- (IBAction)beat1Sound:(id)sender {
    [self playBeatSound:@"beat1" withBeat:0];
}

- (IBAction)beat2Sound:(id)sender {
    [self playBeatSound:@"beat2" withBeat:1];
}

- (IBAction)beat3Sound:(id)sender {
    [self playBeatSound:@"beat3" withBeat:2];
}

- (void)playSound:(NSString *)trackTitle
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:trackTitle ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:soundPath];
    self.effectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [self.effectPlayer setDelegate:self];
    [self.effectPlayer setVolume:1.0];
    [self.effectPlayer play];
}

- (void)playBeatSound:(NSString *)trackTitle withBeat:(int)beatNum
{
    if (![self.beatsPlaying[beatNum] boolValue]) {
        // if this beat is playing, stop it
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:trackTitle ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:soundPath];
        self.beatPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        [self.beatPlayer setDelegate:self];
        [self.beatPlayer setVolume:1.0];
        [self.beatPlayer play];
        
        //set all other beats playing to no
        [self resetBeatsPlaying];
        
        self.beatsPlaying[beatNum] = @YES;
    }
    else {
        [self.beatPlayer stop];
        self.beatsPlaying[beatNum] = @NO;
    }
}

- (void)resetBeatsPlaying
{
    for (int i = 0; i < [self.beatsPlaying count]; i++) {
        self.beatsPlaying[i] = @NO;
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
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
