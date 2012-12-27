#import <CoreGraphics/CoreGraphics.h>
#import "Page.h"


@implementation Page {
  UIWebView *webView;
  UILabel *pageLabel;
}


- (id)init {
  if (self = [super init]) {
    webView = [[UIWebView alloc] init];
    pageLabel = [[UILabel alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor greenColor];

  for (UIView *view in [[[webView subviews] objectAtIndex:0] subviews]) {
    if ([view isKindOfClass:[UIImageView class]]) {
      view.hidden = YES;
    }
  }

  webView.delegate = self;
  webView.scalesPageToFit = YES;
//  webView.scrollView.scrollEnabled = NO;
  webView.backgroundColor = [UIColor clearColor];
  webView.opaque = NO;
  [webView setFrame:CGRectMake(paddingLeft, paddingTop, self.view.bounds.size.width - (paddingLeft + paddingRight), self.view.bounds.size.height - (paddingTop + paddingBottom))];
  [self.view addSubview:webView];

  pageLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
  pageLabel.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + self.view.bounds.size.height - paddingBottom, self.view.bounds.size.width, paddingBottom);
  pageLabel.font = [UIFont fontWithName:@"HiraMinProN-W3" size:12];
  pageLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:pageLabel];
}

- (void)loadFile:(NSString *)filename {
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"html"]]]];
}

- (int)count {
  return (int)ceil(webView.scrollView.contentSize.width / self.view.bounds.size.width);
}

- (void)updatePage:(int)index {
  UIScrollView *scrollView = webView.scrollView;
  scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - webView.bounds.size.width * (index + 1), 0);

  pageLabel.text = [NSString stringWithFormat:@"- %d -", index + 1];
}


/*******************************************************************************
 * UIWebViewDelegate
 ******************************************************************************/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.delegate pageDidFinishLoad:self];
}

- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType {

  NSString *url = [[request URL] absoluteString];
  NSRange range = [url rangeOfString:@"print:"];
  if (range.location != NSNotFound) {
    NSString *message = [[url substringFromIndex:range.length] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"[JavaScript] %@", message);
    return NO;
  }
  return YES;
}


@end