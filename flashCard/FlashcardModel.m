//
//  FlashCardModel.m
//  flashCard
//
//  Created by Alec Fong on 10/15/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import "FlashcardModel.h"

@interface FlashcardModel()
@property (strong, nonatomic) NSMutableArray* flashcards;
@property (strong, nonatomic) NSString* filepath;
@property (strong, nonatomic) Flashcard* noFlashcardsCard;
@end

@implementation FlashcardModel

- (instancetype)init
{
    self = [super init];
    
    _noFlashcardsCard = [[Flashcard alloc] initWithQuestion:@"There are no more flashcards!" answer:@"Please add more flashcards!"];
    
    if (self) {
        // set the _currentIndex
        _currentIndex = 0;
        // get the Document directory and set _filepath
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        // _filepath includes the plist
        _filepath = [rootPath stringByAppendingPathComponent:@"flashCardData.plist"];
        
        
        NSMutableArray* cards = [NSMutableArray arrayWithContentsOfFile:_filepath];
        
        if (!cards) { // no file
            _flashcards = [[NSMutableArray alloc] initWithObjects:
                            [[Flashcard alloc] initWithQuestion:@"Sample Question" answer:@"Sample Answer"],
                            [[Flashcard alloc] initWithQuestion:@"Who is the author of this app?" answer:@"Alec Fong"],nil];
            [self save];
        } else {
            _flashcards = [[NSMutableArray alloc] init];
            NSDictionary* card;
            Flashcard* flashcard;
            
            for (card in cards) {
                flashcard = [[Flashcard alloc] initWithDictionary: card];
                [_flashcards addObject: flashcard];
            }
        }
    }
    return self;
}

+ (instancetype) sharedModel{
    static FlashcardModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}
// Accessing number of flashcards in model
- (NSUInteger) numberOfFlashcards{
    return [self.flashcards count];
}
// Accessing a flashcard – sets currentIndex appropriately
- (Flashcard *) randomFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
     _currentIndex = arc4random()%[self numberOfFlashcards];
    return [self flashcardAtIndex:_currentIndex];
}
- (Flashcard *) flashcardAtIndex: (NSUInteger)index{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
    _currentIndex = index;
    return self.flashcards[self.currentIndex];
}
- (Flashcard *) nextFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
    _currentIndex = self.currentIndex == [self numberOfFlashcards]-1 ? 0:self.currentIndex+1;
    return self.flashcards[self.currentIndex];
}
- (Flashcard *) prevFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
    _currentIndex = 0 > self.currentIndex-1 ? [self numberOfFlashcards]-1:self.currentIndex-1;
    return self.flashcards[self.currentIndex];
}
// Inserting a flashcard
- (void) insertWithQuestion: (NSString *) question
                     answer: (NSString *) ans
                   favorite: (BOOL)fav{
    [self.flashcards addObject:[[Flashcard alloc] initWithQuestion:question answer:ans]];
    [self save];
}
- (void) insertWithQuestion: (NSString *) question
                     answer: (NSString *) ans
                   favorite: (NSNumber *) fav
                    atIndex: (NSUInteger) index{
    [self.flashcards insertObject:[[Flashcard alloc] initWithQuestion:question answer:ans] atIndex:index];
    [self save];
}
// Removing a flashcard
- (void) removeFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return;
    }
    [self.flashcards removeLastObject];
    [self save];
    _currentIndex = 0 > self.currentIndex-1 ? [self numberOfFlashcards]-1:self.currentIndex-1;
}
- (void) removeFlashcardAtIndex: (NSUInteger) index{
    if ([self numberOfFlashcards] < 1) {
        return;
    }
    [self.flashcards removeObjectAtIndex:index];
    [self save];
    
    _currentIndex = 0 > self.currentIndex-1 ? [self numberOfFlashcards]-1:self.currentIndex-1;
}
// Favorite/unfavorite the current flashcard
- (void) toggleFavorite{
    [self save];
    [self.flashcards[self.currentIndex] setIsFavorite:YES];
}
// Getting the favorite flashcards
- (NSArray *) favoriteFlashcards{
    NSMutableArray *favorites = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < [self numberOfFlashcards]; i++) {
        if ([self.flashcards[i] isFavorite]) {
            [favorites addObject:self.flashcards[i]];
        }
    }
    return favorites;
}
- (void) save {
    NSMutableArray* cards = [[NSMutableArray alloc] init];
    Flashcard* card;
    for (card in self.flashcards) {
        [cards addObject: [card dictionary]];
    }
    [cards writeToFile:self.filepath atomically:YES];
}

@end
