//
// ページ
//

#import <UIKit/UIKit.h>

@protocol PageDelegate;


typedef enum {
  paddingLeft = 20,
  paddingRight = 20,
  paddingTop = 30,
  paddingBottom = 30
} PageConfig;

@interface Page : UIViewController <UIWebViewDelegate> {
}

@property(nonatomic, weak) id <PageDelegate> delegate;

- (void)loadFile:(NSString *)filename;

- (int)count;

- (void)updatePage:(int)index;

@end


@protocol PageDelegate <NSObject>

- (void)pageDidFinishLoad:(Page *)page;

@end;