//
// ページ
//

#import <UIKit/UIKit.h>


typedef enum {
  paddingLeft = 20,
  paddingRight = 20,
  paddingTop = 30,
  paddingBottom = 30
} PageConfig;

@interface Page : UIViewController {
  UIWebView *webView;
  UILabel *pageLabel;
}

- (void)loadFile:(NSString *)filename;

- (void)updatePage:(int)index;

@end