//
// ルートの ViewController
//

#import <UIKit/UIKit.h>
#import "Page.h"


typedef enum {
  PAGES_COUNT = 4
} BookConfig;

@interface Book : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, PageDelegate> {

}

@end