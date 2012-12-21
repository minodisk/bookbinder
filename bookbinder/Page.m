#import "Page.h"


@implementation Page


- (id)init {
  if (self = [super init]) {
    webView = [[UIWebView alloc] init];
    pageLabel = [[UILabel alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  webView.scalesPageToFit = YES;
  webView.scrollView.scrollEnabled = NO;
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

- (void)updatePage:(int)index {
  pageLabel.text = [NSString stringWithFormat:@"- %d -", index + 1];
}


@end