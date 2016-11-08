//
//  FlashCardModel.h
//  flashCard
//
//  Created by Alec Fong on 10/15/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashCard.h"

@interface FlashCardModel : NSObject

@property (readonly) long long currentIndex;
// Creating the model
+ (instancetype) sharedModel;
// Accessing number of flashcards in model
- (NSUInteger) numberOfFlashcards;
// Accessing a flashcard – sets currentIndex appropriately
- (FlashCard *) randomFlashcard;
- (FlashCard *) flashcardAtIndex: (NSUInteger)index;
- (FlashCard *) nextFlashcard;
- (FlashCard *) prevFlashcard;
// Inserting a flashcard
- (void) insertWithQuestion: (NSString *) question
                     answer: (NSString *) ans
                   favorite: (BOOL)fav;
- (void) insertWithQuestion: (NSString *) question
                     answer: (NSString *) ans
                   favorite: (NSNumber *) fav
                    atIndex: (NSUInteger) index;
// Removing a flashcard
- (void) removeFlashcard;
- (void) removeFlashcardAtIndex: (NSUInteger) index;
// Favorite/unfavorite the current flashcard
- (void) toggleFavorite;
// Getting the favorite flashcards
- (NSArray *) favoriteFlashcards;
@end
