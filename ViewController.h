//
//  ViewController.h
//  BlueTooth
//
//  Created by meigusd on 16/5/5.
//  Copyright © 2016年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)sendClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
- (IBAction)reLink:(id)sender;


@end

