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
@property int pageCount;
@property int backCount;
@property NSString *urlFix;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCount = 0;
    self.backCount = 0;
    self.webView.scrollView.delegate = self;
}

/*[self.view addConstraints:[NSLayoutConstraint
 constraintsWithVisualFormat:@"V:|-[myView(>=748)]-|"
 options:NSLayoutFormatDirectionLeadingToTrailing
 metrics:nil
 views:NSDictionaryOfVariableBindings(myView)]];
 */


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
    } else if ([textField.text rangeOfString:@"https://"].location == NSNotFound) {
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

- (IBAction)onTeaserPressed:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Coming soon!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirm];
    
    [self presentViewController:alertController animated:YES completion:nil];
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f", scrollView.contentOffset.y);
    CGRect rect = [self.view viewWithTag:10].frame;
    [self.view viewWithTag:10].frame = CGRectMake(0, scrollView.contentOffset.y * -1, rect.size.width, rect.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    [self.view viewWithTag:10].alpha = (68.0 - scrollView.contentOffset.y)/68.0;
    
    [UIView commitAnimations];
    

    
    /*if (scrollView.contentOffset.y < -68) {
        self.topConstraint.constant = 68.0 - scrollView.contentOffset.y;

    }*/
    NSString *constraint = [NSString stringWithFormat:@"V:|-spacing[self.webView(==%f)]|", 68.0 - scrollView.contentOffset.y];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:constraint
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(self.webView)]];
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
