//
//  ViewController.m
//  flashCard
//
//  Created by Alec Fong on 10/15/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionAnswerLabel;
@property (strong, nonatomic) FlashCardModel* flashCardModel;
@property (strong, nonatomic) FlashCard* currentFlashCard;
@property BOOL isAnswerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _flashCardModel = [FlashCardModel sharedModel];
    _currentFlashCard = [_flashCardModel randomFlashcard];
    [_questionAnswerLabel setText:[_currentFlashCard question]];
    _isAnswerView = false;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(singleTapRecognized:)];
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(doubleTapRecognized:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeRightRecognized:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(swipeLeftRecognized:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
}

- (void) singleTapRecognized: (UITapGestureRecognizer *) recognizer {
    self.currentFlashCard = [self.flashCardModel randomFlashcard];
    [self.questionAnswerLabel setText:[self.currentFlashCard question]];
    self.isAnswerView = false;
}
- (void) doubleTapRecognized: (UITapGestureRecognizer *) recognizer {
    if (self.isAnswerView) {
        [self.questionAnswerLabel setText: [self.currentFlashCard question]];
        self.questionAnswerLabel.textColor = [UIColor blackColor];
    } else {
        [self.questionAnswerLabel setText:[self.currentFlashCard answer]];
        self.questionAnswerLabel.textColor = [UIColor cyanColor];
    }
    
    self.isAnswerView = !_isAnswerView;
}
- (void) swipeRightRecognized: (UITapGestureRecognizer *) recognizer {
    self.currentFlashCard = [self.flashCardModel nextFlashcard];
    self.questionAnswerLabel.textColor = [UIColor blackColor];
    self.questionAnswerLabel.alpha = 0;
    self.questionAnswerLabel.text = [self.currentFlashCard question];
    [UIView animateWithDuration:1.0 animations:^{
        self.questionAnswerLabel.alpha = 1;    }];
    self.isAnswerView = false;
}
- (void) swipeLeftRecognized: (UITapGestureRecognizer *) recognizer {
    self.currentFlashCard = [self.flashCardModel prevFlashcard];
    self.questionAnswerLabel.textColor = [UIColor blackColor];
    [self.questionAnswerLabel setText:[self.currentFlashCard question]];
    self.questionAnswerLabel.alpha = 0;
    self.questionAnswerLabel.text = [self.currentFlashCard question];
    [UIView animateWithDuration:1.0 animations:^{
        self.questionAnswerLabel.alpha = 1;
    }];
    self.isAnswerView = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
