//
//  permutation.h
//  permutation
//
//  Created by Erran Carey on 3/8/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

@interface NSArray (PermutationAdditions)

- (NSArray *)allPermutations;
NSInteger *pc_next_permutation(NSInteger *perm, const NSInteger size);

@end