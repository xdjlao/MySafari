//
//  RootViewController.m
//  MySafari
//
//  Created by Jerry on 1/12/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *websiteTitle;
@property int pageCount;
@property int backCount;
@property NSString *urlFix;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property CGRect rect;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageCount = 0;
    self.backCount = 0;
    self.webView.scrollView.delegate = self;
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
    self.urlTextField.text = self.webView.request.URL.absoluteString;
    self.websiteTitle.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageCount++;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Page not found!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *goBack = [UIAlertAction actionWithTitle:@"Go back" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.webView goBack];
    }];
    
    [alertController addAction:goBack];
    [self.activityIndicator stopAnimating];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField.text rangeOfString:@"http://"].location == NSNotFound) {
        if([textField.text rangeOfString:@"https://"].location == NSNotFound) {
            self.urlFix = [NSString stringWithFormat:@"http://%@", textField.text];
        } else {
            self.urlFix = textField.text;
        }
    } else {
        self.urlFix = textField.text;
    }
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

- (IBAction)onTeaserPressed:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Coming soon!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirm];
    
    [self presentViewController:alertController animated:YES completion:nil];
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.rect = [self.view viewWithTag:10].frame;
    float frameHeight = self.rect.size.height;
    float frameHeightMargin = self.rect.size.height - 20;
    
    [self.view viewWithTag:10].frame = CGRectMake(0, scrollView.contentOffset.y * -1, self.rect.size.width, frameHeight);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    if(scrollView.contentOffset.y <= frameHeight) {
        [self.view viewWithTag:10].alpha = (frameHeight - scrollView.contentOffset.y)/frameHeight;
    
        self.topLayoutConstraint.constant = frameHeightMargin - scrollView.contentOffset.y;
    }
    
    [UIView commitAnimations];
    
}

- (IBAction)onBackgroundTapped:(UITapGestureRecognizer *)sender {
    [self.urlTextField resignFirstResponder];
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
