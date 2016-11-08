//
//  AddViewController.h
//  flashCard
//
//  Created by Alec Fong on 11/7/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddCompletionHandler)(NSString *question, NSString *answer);

@interface AddViewController : UIViewController

@property (copy, nonatomic) AddCompletionHandler completionHandler;

@end
