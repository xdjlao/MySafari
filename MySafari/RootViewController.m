//
//  RootViewController.m
//  MySafari
//
//  Created by Jerry on 1/12/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIWebViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property int pageCount;
@property int backCount;
@property NSString *urlFix;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageCount = 0;
    self.backCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    self.pageCount++;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField.text rangeOfString:@"http://"].location == NSNotFound) {
        self.urlFix = [@"http://" stringByAppendingString:textField.text];
    } else {
        self.urlFix = textField.text;
    }
    NSLog(@"%@", self.urlFix);
    NSURL *url = [NSURL URLWithString:self.urlFix];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    return YES;
}

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    if(self.pageCount > 0){
        [self.webView goBack];
        self.pageCount--;
        self.backCount++;
    }
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    if(self.backCount > 0 ) {
        [self.webView goForward];
    }
    
}


- (IBAction)onStopLoadingButtonPressed:(UIButton *)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
