#import "Book.h"


@implementation Book


- (id)init {
  if (self = [super init]) {
    cutter = [[Cutter alloc] init];

    NSMutableArray *mPages = [NSMutableArray array];
    Page *page;
    int i = PAGES_COUNT;
    while (i--) {
      page = [[Page alloc] init];
      [mPages addObject:page];
    }
    pages = [NSArray arrayWithArray:mPages];

    pageIndex = 0;
    pageCount = 10;

    pageViewController = [[UIPageViewController alloc]
      initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                      options:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor redColor];

  [self addChildViewController:cutter];
  [self.view addSubview:cutter.view];

  pageViewController.view.backgroundColor = [UIColor yellowColor];
  pageViewController.delegate = self;
  pageViewController.dataSource = self;
  pageViewController.view.frame = self.view.bounds;
  [self addChildViewController:pageViewController];
//  [self.view addSubview:pageViewController.view];
  [pageViewController setViewControllers:[NSArray arrayWithObject:[self getPageAt:pageIndex]]
                               direction:UIPageViewControllerNavigationDirectionForward
                                animated:NO completion:NULL];

  [self willRotateToInterfaceOrientation:self.interfaceOrientation
                                duration:0.4];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
  [self load:@"rashomon"];
}

- (void)load:(NSString *)filename {
  // サイズ計測用 UIWebView にファイルをロードする
  [cutter loadFile:filename];

  // ページにファイルをロードする
  Page *page;
  for (NSUInteger i = 0; i < PAGES_COUNT; i++) {
    page = [pages objectAtIndex:i];
    [page loadFile:filename];
  }
}

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


/*******************************************************************************
 * UIPageViewController delegation
 ******************************************************************************/

- (UIViewController *)pageViewController:(UIPageViewController *)this
      viewControllerBeforeViewController:(UIViewController *)page {
  return [self getRelativePageAt:-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)this
       viewControllerAfterViewController:(UIViewController *)page {
  return [self getRelativePageAt:1];
}

- (void)pageViewController:(UIPageViewController *)this
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
  NSLog(@"didFinishAnimating finished=%d, transitionCompleted=%d", finished, completed);
}


@end