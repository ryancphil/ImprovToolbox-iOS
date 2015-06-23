//
//  TwitterWebViewController.m
//  Improv Toolbox
//
//  Created by Sydney Richardson on 11/20/14.
//  Copyright (c) 2014 Gainesville Improv Festival. All rights reserved.
//

#import "TwitterWebViewController.h"

@interface TwitterWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *twitterPageWebView;

@end

@implementation TwitterWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSString *twitterURL = @"https://twitter.com/gvilleimprov";
    NSURL *url = [NSURL URLWithString:twitterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.twitterPageWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
