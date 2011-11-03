//
//  ViewController.m
//  EffectPicSlideV2
//
//  Created by Kaijie Yu on 10/27/11.
//  Copyright (c) 2011 thePlant. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize _images;
@synthesize _scrollView;
@synthesize _topbarView;
@synthesize _pageControl;
@synthesize _buttonBack;
@synthesize _scrollViewFullScreen;
@synthesize backgroundView = backgroundView_;

// ---------------------------------------------------------------------------
- (void)dealloc
{
  [_scrollView release];
  [_topbarView release];
  [_pageControl release];
  [_buttonBack release];
  [_images release];
  [backgroundView_ release];
}

// ---------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle
// ---------------------------------------------------------------------------
- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [_scrollView setBounds:CGRectMake(0, 0, 320, 480)];
  [self setImageSlideView:_scrollView];
  
  // Add tap gesture recognizer for scroll view
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [_scrollView addGestureRecognizer:tapGestureRecognizer];
  [tapGestureRecognizer release];
  
  [_scrollView setShowsHorizontalScrollIndicator:NO];
  [_scrollView setShowsVerticalScrollIndicator:NO];
  [_scrollView setAutoresizesSubviews:NO];
  [_scrollView setDelegate:self];
  [_scrollView setContentMode:UIViewContentModeTop];
  
  // Setting background transparent view
  backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  [backgroundView_ setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
  [self.view insertSubview:backgroundView_ belowSubview:_scrollView];
  
  _scrollViewFullScreen = YES;
}

// ---------------------------------------------------------------------------
- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  self._scrollView = nil;
  self._topbarView = nil;
  self._pageControl = nil;
  self._buttonBack = nil;
  self.backgroundView = nil;
}

// ---------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface Orientation
// ---------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  return NO; // Lock landscape
}

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [_scrollView setBounds:CGRectMake(0, 0, 320, 480)];
  [self updateImageSlideView:_scrollView];
}*/


//////////////////////////////////////////////////////////////////////////////
#pragma mark - Custom
// ---------------------------------------------------------------------------
- (void)setImageSlideView:(UIScrollView *)imageSlideView
{
  _images = [[NSMutableArray alloc] initWithObjects:
             [UIImage imageNamed:@"NTCInfoBg_640x960.jpg"],
             [UIImage imageNamed:@"NTCHomeMainPic_640x960.jpg"],
             [UIImage imageNamed:@"Eight_640x960.png"],
             [UIImage imageNamed:@"NTCInfoBg_640x960.jpg"],
             [UIImage imageNamed:@"NTCHomeMainPic_640x960.jpg"],
             [UIImage imageNamed:@"Eight_640x960.png"],
             [UIImage imageNamed:@"NTCInfoBg_640x960.jpg"],
             [UIImage imageNamed:@"NTCHomeMainPic_640x960.jpg"],
             [UIImage imageNamed:@"Eight_640x960.png"],
             nil];
  
  [imageSlideView setContentSize:CGSizeMake((imageSlideView.bounds.size.width + kImageMargin) * [_images count], imageSlideView.bounds.size.height)];
  [imageSlideView setPagingEnabled:YES];
  [imageSlideView setFrame:CGRectMake(0.0f, 0.0f, 320.0f + kImageMargin, 480.0f)];
  
  NSInteger i = -1;
  for (UIImage * image in _images) {
    UIImageView *newPage = [[[UIImageView alloc] initWithImage:image] autorelease];
    [newPage setFrame:CGRectMake((320.0f + kImageMargin) * ++i, 0.0f, 320.0f, 480.0f)];
    
    [newPage setUserInteractionEnabled:YES];
    [newPage setContentScaleFactor:1.0f];
//    [newPage setContentMode:UIViewContentModeScaleAspectFit];
    [newPage setContentMode:UIViewContentModeCenter];
    [newPage setClipsToBounds:YES];
    [imageSlideView addSubview:newPage];
  }
  
  _pageControl.numberOfPages = [_images count];
  _pageControl.currentPage = 0;//_currPageIndex;
  [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

// ---------------------------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)sender {
  // Update the page when more than 50% of the previous/next page is visible
  _pageControl.currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
}

// ---------------------------------------------------------------------------
- (IBAction)changePage:(id)sender
{
  // update the scroll view to the appropriate page
  CGRect frame;
  frame.origin.x = _scrollView.frame.size.width * _pageControl.currentPage;
  frame.origin.y = 0;
  frame.size = _scrollView.frame.size;
  [_scrollView scrollRectToVisible:frame animated:YES];
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark - Gesture Handler
// ---------------------------------------------------------------------------
- (void)handleTapGesture:(id)sender
{
  if (_scrollViewFullScreen) {
    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    if (_topbarView.alpha < 0.5f) [_topbarView setAlpha:1.0f];
    else [_topbarView setAlpha:0.0f];
    
    [UIView commitAnimations];
  } else {
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [_scrollView setFrame:CGRectMake(0.0f, 0.0f, 320.0f + kImageMargin, 480.0f)];
    
    NSInteger i = -1;
    for (UIImageView * thePage in [_scrollView subviews]) {
      //[thePage setContentScaleFactor:1.0f];
      [thePage setBounds:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
      [thePage setFrame:CGRectMake((320.0f + kImageMargin) * ++i, 0.0f, 320.0f, 480.0f)];
    }
    
    [_topbarView setAlpha:1.0f];
    [backgroundView_ setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
    [UIView commitAnimations];
    
    // Reset the content of scroll view
    [_scrollView setContentSize:CGSizeMake(
                                           _scrollView.contentSize.width + (kImageMargin + 20) * [_images count], 
                                           _scrollView.contentSize.height )];
    [_scrollView setContentOffset:CGPointMake(340.0f * _pageControl.currentPage, 0.0f)];
    
    _scrollViewFullScreen = YES;
  }
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark - Button IBAcion
// ---------------------------------------------------------------------------
- (IBAction)scaleBackToSmall:(id)sender
{  
  [UIView beginAnimations:@"scale" context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  [UIView setAnimationBeginsFromCurrentState:YES];
  [UIView setAnimationDuration:0.3];
  
  [_topbarView setAlpha:0.0f];
  
  NSInteger i = -1;
  for (UIImageView * thePage in [_scrollView subviews]) {
    //[thePage setContentScaleFactor:1.2f];
    [thePage setBounds:CGRectMake(0.0f, (480.0f - kSmallImageHeight) / 2.0f, 300.0f, kSmallImageHeight)];
    [thePage setFrame:CGRectMake(300.0f * ++i, 0.0f, 300.0f, kSmallImageHeight)];
  }

  [_scrollView setFrame:CGRectMake(10.0f, kSmallImageMarginTop, 300.0f, 480.0f)];
  [_scrollView setContentOffset:CGPointMake(300.0f * _pageControl.currentPage, 0.0f)];
  [backgroundView_ setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0f]];
  [UIView commitAnimations];

  // Reset the content of scroll view
  [_scrollView setContentSize:CGSizeMake(
                                         _scrollView.contentSize.width - (kImageMargin + 20) * [_images count], 
                                         _scrollView.contentSize.height )];
  
  
  _scrollViewFullScreen = NO;
}

@end
