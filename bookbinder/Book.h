//
// ルートの ViewController
//

#import <UIKit/UIKit.h>
#import "Cutter.h"
#import "Page.h"


typedef enum {
  PAGES_COUNT = 4
} BookConfig;

@interface Book : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
  Cutter *cutter;
  NSArray *pages;
  UIPageViewController *pageViewController;
  int pageIndex;
  int pageCount;
}

@end