//
//  DetailViewController.m
//  GongSuo
//
//  Created by 邓鹏 on 14/9/7.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    UIWebView *webView;
}
@end

@implementation DetailViewController

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
    [self setTitle:NSLocalizedString(@"introduct", nil)];
    [super viewDidLoad];
    
    CGRect rect = self.navigationController.view.frame;
    webView = [[UIWebView alloc] initWithFrame:rect];
    [self.view addSubview:webView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"language", nil) ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                target:self action:@selector(cancelPresentViewController)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                 target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)search{
    NSURL* url = [[NSURL alloc] initWithString:NSLocalizedString(@"search", nil)];
    [[UIApplication sharedApplication]openURL:url];
}

- (void)cancelPresentViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
