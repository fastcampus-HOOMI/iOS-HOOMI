//
//  UMAlertView.m
//  UMAlertView
//
//  Created by Jyo on 2016. 7. 22..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "UMAlertView.h"

#define UM_ALERT_VIEW_CORNER_RADIUS 3.0f // AlertView Corner Radius
#define UM_ALERT_VIEW_MARGIN_ZERO 0.0f
#define UM_ALERT_VIEW_MARGIN 50.0f
#define UM_ALERT_VIEW_HEIGHT 50.0f
#define UM_ALERT_BUTTON_HEIGHT 40.0f
#define UM_ALERT_VIEW_TITLE_TEXT_COLOR [UIColor blackColor] // AlertView Title Color
#define UM_ALERT_VIEW_SELECT_BUTTON_COLOR [UIColor grayColor] // AlertView Button Background Color
#define UM_ALERT_VIEW_SELECT_CANCEL_BUTTON_COLOR [UIColor lightGrayColor]
#define UM_ALERT_VIEW_ALL_BACKGROUND_COLOR [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
#define UM_ALERT_VIEW_SELECT_BUTTON_TITLE @"Select" // AlertView Button Title
#define UM_ALERT_VIEW_SELECT_CANCEL_BUTTON_TITLE @"Cancel"

static CGFloat duration = 1.0f;
static NSArray *pickerListData = nil;
static BOOL isScrollPickerView = NO;


@interface UMAlertView()

@property (nonatomic, weak) UIView *umAlertView;
@property (nonatomic, weak) UILabel *alertTitleLabel;
@property (nonatomic, weak) UIPickerView *dataPicker;
@property (nonatomic, weak) UIButton *selectButton;
@end

@implementation UMAlertView

// title, data
- (void)um_showAlertViewTitle:(NSString *)title pickerData:(NSArray *)data haveCancelButton:(BOOL)haveCancelButton  {
    
    [self um_showAlertViewTitle:title pickerData:data duration:duration haveCancelButton:haveCancelButton completion:nil];
}

// title, data, completion block
- (void)um_showAlertViewTitle:(NSString *)title pickerData:(NSArray *)data haveCancelButton:(BOOL)haveCancelButton completion:(void (^)(void))completed {
    
    [self um_showAlertViewTitle:title pickerData:data duration:duration haveCancelButton:haveCancelButton completion:completed];
}

// title, data, animation time
- (void)um_showAlertViewTitle:(NSString *)title pickerData:(NSArray *)data haveCancelButton:(BOOL)haveCancelButton duration:(CGFloat)time {
    
    [self um_showAlertViewTitle:title pickerData:data duration:time haveCancelButton:haveCancelButton completion:nil];
}

// title, data, animation time, completion block
- (void)um_showAlertViewTitle:(NSString *)title pickerData:(NSArray *)data duration:(CGFloat)time haveCancelButton:(BOOL)haveCancelButton completion:(void (^)(void))completed {
    
    pickerListData = data;
    duration = time;
    isScrollPickerView = NO;
    
    UIView *keyWindow = [self keyWindow];
    
    UIView *umAlertView =[[UIView alloc] initWithFrame:CGRectMake(UM_ALERT_VIEW_MARGIN_ZERO, UM_ALERT_VIEW_MARGIN_ZERO, keyWindow.frame.size.width - UM_ALERT_VIEW_MARGIN * 2, UM_ALERT_VIEW_MARGIN * 4)];
    [umAlertView setCenter:keyWindow.center];
    umAlertView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    umAlertView.backgroundColor = UM_ALERT_VIEW_ALL_BACKGROUND_COLOR;
    umAlertView.layer.borderWidth = 2.0f;
    umAlertView.layer.cornerRadius = 3 * UM_ALERT_VIEW_CORNER_RADIUS;
    umAlertView.clipsToBounds = YES;
    umAlertView.alpha = 0.0f;
    self.umAlertView = umAlertView;
    
    UIToolbar *naviToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(UM_ALERT_VIEW_MARGIN_ZERO, UM_ALERT_VIEW_MARGIN_ZERO, self.umAlertView.frame.size.width, 44.0f)];
    [naviToolbar setTintColor:[UIColor grayColor]];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5.f, UM_ALERT_VIEW_MARGIN_ZERO, 50.f, 44.f)];
    [cancelButton setTitle:@"취소" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(alertCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.umAlertView.frame.size.width - 5.f - cancelButton.frame.size.width, UM_ALERT_VIEW_MARGIN_ZERO, 50.f, 44.f)];
    [saveButton setTitle:@"선택" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(alertButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.f,UM_ALERT_VIEW_MARGIN_ZERO, umAlertView.frame.size.width - cancelButton.frame.size.width - saveButton.frame.size.width, 44.f)];
    [alertTitleLabel setText:title];
    [alertTitleLabel setTextColor:UM_ALERT_VIEW_TITLE_TEXT_COLOR];
    [alertTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [alertTitleLabel setFont:[UIFont boldSystemFontOfSize:17.f]];
    [naviToolbar addSubview:alertTitleLabel];
    self.alertTitleLabel = alertTitleLabel;
    
    
    [naviToolbar addSubview:saveButton];
    [naviToolbar addSubview:cancelButton];
    
    [self.umAlertView addSubview:naviToolbar];

    UIPickerView *dataPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(UM_ALERT_VIEW_MARGIN_ZERO, naviToolbar.frame.size.height, umAlertView.frame.size.width, umAlertView.frame.size.height - naviToolbar.frame.size.height)];
    dataPicker.backgroundColor = UM_ALERT_VIEW_ALL_BACKGROUND_COLOR;
    dataPicker.delegate = self;
    dataPicker.dataSource = self;
    [umAlertView addSubview:dataPicker];
    self.dataPicker = dataPicker;
    
    if(!haveCancelButton) {
        [cancelButton setHidden:YES];
    }
    
    [keyWindow addSubview:self.umAlertView];
    
    [UIView animateWithDuration:duration animations: ^{
        NSLog(@"animation");
        umAlertView.alpha = 1.0f;
        completed();
    }];
    
}

- (void)um_dismissAlertView {
    
    [UIView animateWithDuration:duration animations:^{
        NSLog(@"anmiation");
        self.umAlertView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.umAlertView removeFromSuperview];
    }];
    
}

- (void)um_dismissAlertViewCompletion:(void(^)(void))complete {
    
    [UIView animateWithDuration:duration animations:^{
        NSLog(@"anmiation");
        self.umAlertView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.umAlertView removeFromSuperview];
        complete();
    }];
    
}

- (UIView *)keyWindow {
    return [UIApplication sharedApplication].delegate.window;
}

// delegate
- (void)alertButtonAction {
    NSLog(@"alertButtonAction");
    
    if(!isScrollPickerView) {
        self.selectData = [pickerListData objectAtIndex:0];
    } else {
        self.selectData = [pickerListData objectAtIndex:self.pickerRow];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectUMAlertButton)]) {
        [self.delegate selectUMAlertButton];
    }
}

- (void)alertCancelButtonAction {
    NSLog(@"alertCancelButtonAction");
    
    if ([self.delegate respondsToSelector:@selector(selectUMAlertCancelButton)]) {
        [self.delegate selectUMAlertCancelButton];
    }
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerListData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [pickerListData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    isScrollPickerView = YES;
    self.pickerRow = row;
    
}

@end
