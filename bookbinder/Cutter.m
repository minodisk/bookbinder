#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "Cutter.h"
#import "Page.h"


@implementation Cutter


- (id)init {
  if (self = [super init]) {
    webView = [[UIWebView alloc] init];
    imageView = [[UIImageView alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  webView.delegate = self;
//  webView.scrollView.scrollEnabled = NO;
  webView.opaque = NO;
  webView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:webView];

  [self.view addSubview:imageView];
}

- (void)loadFile:(NSString *)filename {
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"html"]]]];
}


/*******************************************************************************
 * UIWebView delegation
 ******************************************************************************/

- (void)webViewDidFinishLoad:(UIWebView *)wv {
  width = self.view.bounds.size.width - (paddingLeft + paddingRight);

  wv.frame = CGRectMake(0, 0, self.view.bounds.size.width - (paddingLeft + paddingRight), self.view.bounds.size.height - (paddingTop + paddingBottom));
  wv.scalesPageToFit = YES;

  UIScrollView *scrollView = wv.scrollView;

  NSLog(@"%f, %f", webView.frame.size.width, webView.frame.size.height);
  NSLog(@"%f, %f", scrollView.frame.size.width, scrollView.frame.size.height);
  NSLog(@"%f, %f", scrollView.contentSize.width, scrollView.contentSize.height);

  contentSize = scrollView.contentSize;
  webView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
  imageView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
  [self performSelector:@selector(renderWebContent)
             withObject:nil afterDelay:1.0];
}

- (void)renderWebContent {
  UIGraphicsBeginImageContext(contentSize);
//  UIGraphicsBeginImageContext(CGSizeMake(contentSize.height, contentSize.width));
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0, contentSize.width);
  CGContextScaleCTM(context, -1, -1);
  CGContextRotateCTM(context, (CGFloat) M_PI / 2);
  [webView.layer renderInContext:context];
  imageView.image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  webView.frame = CGRectMake(webView.frame.origin.x-1000, webView.frame.origin.y, webView.frame.size.width, webView.frame.size.height);
//  [webView removeFromSuperview];

  NSMutableArray *blanks = [NSMutableArray array];

  UIImage *image = imageView.image;
  CGImageRef imageRef = image.CGImage;
  CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
  CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
  UInt8 *buffer = (UInt8 *) CFDataGetBytePtr(dataRef);
  size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
  for (int y = 0; y < image.size.height; y++) {
    [blanks insertObject:[NSNumber numberWithBool:YES] atIndex:(NSUInteger) y];
    for (int x = 0; x < image.size.width; x++) {
      UInt8 *pixel = buffer + bytesPerRow * y + 4 * x;
      UInt8 a = *(pixel + 3);
      UInt8 r = *(pixel + 2);
      UInt8 g = *(pixel + 1);
      UInt8 b = *(pixel + 0);

      if (a != 0) {
//        NSLog(@"y: %d, x: %d, r: %d, g: %d, b: %d, a: %d", y, x, r, g, b, a);
        [blanks insertObject:[NSNumber numberWithBool:NO] atIndex:(NSUInteger)y];
        break;
      }
    }
  }


}


@end