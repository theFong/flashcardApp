//
//  AddViewController.m
//  flashCard
//
//  Created by Alec Fong on 11/7/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _saveButton.enabled = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (self.completionHandler) {
        self.completionHandler(self.questionTextView.text, self.answerTextField.text);
    }
    
    self.questionTextView.text = nil;
    self.answerTextField.text = nil;
    
    return YES;
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void) enableSaveButtonForFlashCard: (NSString *) questionText answer: (NSString *) answerText{
//    NSLog(@"%s",(questionText.length > 0 && answerText.length > 0) ? "true":"false");
    self.saveButton.enabled = (questionText.length > 0 && answerText.length > 0);
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self enableSaveButtonForFlashCard:self.questionTextView.text answer:changedString];
    return YES;
}

-  (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.questionTextView resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.questionTextView resignFirstResponder];
    [self.answerTextField resignFirstResponder];
    
    //completion handler
    if (self.completionHandler) {
        self.completionHandler(nil,nil);
    }
    
    self.questionTextView.text = nil;
    self.answerTextField.text = nil;
}
- (IBAction)saveButtonTapped:(id)sender {
    [self.questionTextView resignFirstResponder];
    [self.answerTextField resignFirstResponder];
    
    //completion handler
    if (self.completionHandler) {
        self.completionHandler(self.questionTextView.text, self.answerTextField.text);
    }
    
    self.questionTextView.text = nil;
    self.answerTextField.text = nil;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
