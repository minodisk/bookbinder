//
// 行を跨いでページを裁断するクラス
// ・ページをロードし、ロード完了時に指定サイズに収まる様に裁断する
//

#import <UIKit/UIKit.h>


@interface Cutter : UIViewController <UIWebViewDelegate> {
  UIWebView *webView;
  UIImageView *imageView;
  CGSize contentSize;
  CGFloat width;
}

- (void)loadFile:(NSString *)filename;

@end