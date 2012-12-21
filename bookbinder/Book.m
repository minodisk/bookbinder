#import "Book.h"
#import "Page.h"


@implementation Book {
  UIPageViewController *pageViewController;
  NSArray *pages;
  int pageIndex;
  int pageCount;
  int loadedCount;
}


- (id)init {
  if (self = [super init]) {
    pageViewController = [[UIPageViewController alloc]
      initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                      options:nil];

    NSMutableArray *tmpPages = [NSMutableArray array];
    int i = PAGES_COUNT;
    Page *page;
    while (i--) {
      page = [[Page alloc] init];
      page.delegate = self;
      [tmpPages addObject:page];
    }
    pages = tmpPages;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor redColor];

  pageViewController.view.backgroundColor = [UIColor yellowColor];
  pageViewController.delegate = self;
  pageViewController.dataSource = self;
  pageViewController.view.frame = self.view.bounds;
  [self addChildViewController:pageViewController];
  [self.view addSubview:pageViewController.view];

  int i = PAGES_COUNT;
  Page *page;
  while (i--) {
    page = [pages objectAtIndex:i];
    [self.view addSubview:page.view];
  }

  [self loadFile:@"rashomon"];
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//                                duration:(NSTimeInterval)duration {
//}

- (Page *)getRelativePageAt:(int)deltaIndex {
  int index = pageIndex + deltaIndex;
  if (index < 0) {
    index = 0;
  } else if (index > pageCount - 1) {
    index = pageCount - 1;
  }
  if (index == pageIndex) {
    return nil;
  }
  pageIndex = index;
  return [self getPageAt:pageIndex];
}

- (Page *)getPageAt:(int)index {
  Page *page = [pages objectAtIndex:index % PAGES_COUNT];
  [page updatePage:index];
  return page;
}

- (void)loadFile:(NSString *)filename {
  loadedCount = 0;
  int i = PAGES_COUNT;
  Page *page;
  while (i--) {
    page = [pages objectAtIndex:i];
    [page loadFile:filename];
  }
}


/*******************************************************************************
 * PageDelegate
 ******************************************************************************/

- (void)pageDidFinishLoad:(Page *)page {
  if (++loadedCount == PAGES_COUNT) {
    int i = PAGES_COUNT;
    Page *page;
    while (i--) {
      page = [pages objectAtIndex:i];
      [page.view removeFromSuperview];
    }

    pageIndex = 0;
    pageCount = [page count];

    [pageViewController setViewControllers:[NSArray arrayWithObject:[self getPageAt:pageIndex]]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO completion:NULL];
  }
}


/*******************************************************************************
 * PageDelegate
 ******************************************************************************/

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)page {
  return [self getRelativePageAt:-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)page {
  return [self getRelativePageAt:1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
  NSLog(@"didFinishAnimating finished=%d, transitionCompleted=%d", finished, completed);
}


@end