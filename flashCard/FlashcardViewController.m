//
//  ViewController.m
//  flashCard
//
//  Created by Alec Fong on 10/15/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import "FlashcardViewController.h"

@interface FlashcardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionAnswerLabel;
@property (strong, nonatomic) FlashcardModel* flashcardModel;
@property (strong, nonatomic) Flashcard* currentFlashcard;
@property BOOL isAnswerView;
@end

@implementation FlashcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _flashcardModel = [FlashcardModel sharedModel];
    _currentFlashcard = [_flashcardModel randomFlashcard];
    [_questionAnswerLabel setText:[_currentFlashcard question]];
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
    self.currentFlashcard = [self.flashcardModel randomFlashcard];
    [self.questionAnswerLabel setText:[self.currentFlashcard question]];
    self.isAnswerView = false;
}
- (void) doubleTapRecognized: (UITapGestureRecognizer *) recognizer {
    if (self.isAnswerView) {
        [self.questionAnswerLabel setText: [self.currentFlashcard question]];
        self.questionAnswerLabel.textColor = [UIColor blackColor];
    } else {
        [self.questionAnswerLabel setText:[self.currentFlashcard answer]];
        self.questionAnswerLabel.textColor = [UIColor cyanColor];
    }
    
    self.isAnswerView = !_isAnswerView;
}
- (void) swipeRightRecognized: (UITapGestureRecognizer *) recognizer {
    self.currentFlashcard = [self.flashcardModel nextFlashcard];
    self.questionAnswerLabel.textColor = [UIColor blackColor];
    self.questionAnswerLabel.alpha = 0;
    self.questionAnswerLabel.text = [self.currentFlashcard question];
    [UIView animateWithDuration:1.0 animations:^{
        self.questionAnswerLabel.alpha = 1;    }];
    self.isAnswerView = false;
}
- (void) swipeLeftRecognized: (UITapGestureRecognizer *) recognizer {
    self.currentFlashcard = [self.flashcardModel prevFlashcard];
    self.questionAnswerLabel.textColor = [UIColor blackColor];
    [self.questionAnswerLabel setText:[self.currentFlashcard question]];
    self.questionAnswerLabel.alpha = 0;
    self.questionAnswerLabel.text = [self.currentFlashcard question];
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
