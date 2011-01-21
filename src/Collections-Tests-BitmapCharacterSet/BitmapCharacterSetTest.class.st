Class {
	#name : #BitmapCharacterSetTest,
	#superclass : #TestCase,
	#category : #'Collections-Tests-BitmapCharacterSet'
}

{ #category : #accessing }
BitmapCharacterSetTest >> absentCharacters [
	"This returns the neighboring characters of each element of #characters, provided they
	are not also elements of #characters"

	| absentCharacters |

	absentCharacters := OrderedCollection new.
	self characters do: [:each | | asciiValue nextChar previousChar |
		(asciiValue := each asciiValue) > 0
			ifTrue: [
				previousChar := Character value: asciiValue - 1.
				(self characters includes: previousChar)
					ifFalse: [absentCharacters add: previousChar]].
		nextChar := Character value: asciiValue + 1.
		(self characters includes: nextChar)
			ifFalse: [absentCharacters add: nextChar]].
	^ absentCharacters asArray.
]

{ #category : #accessing }
BitmapCharacterSetTest >> characterSetClass [
	^ BitmapCharacterSet
]

{ #category : #accessing }
BitmapCharacterSetTest >> characters [
	^ #(0 50 100 200 255 256 500 1000) collect: [:each | Character value: each]
]

{ #category : #accessing }
BitmapCharacterSetTest >> emptyCharacterSet [
	^ self characterSetClass new
]

{ #category : #accessing }
BitmapCharacterSetTest >> nonEmptyCharacterSet [
	^ self characterSetClass newFrom: self characters
]

{ #category : #tests }
BitmapCharacterSetTest >> testAdd [
	| set |

	set := self emptyCharacterSet.
	self
		deny: (self characters anySatisfy: [:each | set includes: each]);
		assert: (self characters allSatisfy: [:each | (set add: each) == each]);
		assert: (self characters allSatisfy: [:each | set includes: each]).
]

{ #category : #tests }
BitmapCharacterSetTest >> testCapacity [
	self
		assert: (self characterSetClass new: 256) capacity = 256;
		assert: (self characterSetClass new: 257) capacity = 264;
		assert: (self characterSetClass new: 500) capacity = 504
]

{ #category : #tests }
BitmapCharacterSetTest >> testDo [
	| set enumerated |

	set := self emptyCharacterSet.
	enumerated := OrderedCollection new.

	set do: [:each | enumerated add: each].
	self assert: enumerated isEmpty.

	set addAll: self characters.
	set do: [:each | enumerated add: each].
	self assert: enumerated asArray = self characters asArray.
]

{ #category : #tests }
BitmapCharacterSetTest >> testEquals [
	self
		assert: self emptyCharacterSet = self emptyCharacterSet;
		assert: self nonEmptyCharacterSet = self nonEmptyCharacterSet;
		deny: self emptyCharacterSet = self nonEmptyCharacterSet;
		deny: self nonEmptyCharacterSet = self emptyCharacterSet.
]

{ #category : #tests }
BitmapCharacterSetTest >> testHash [
	self
		assert: self emptyCharacterSet hash = self emptyCharacterSet hash;
		assert: self nonEmptyCharacterSet hash = self nonEmptyCharacterSet hash;
		deny: self emptyCharacterSet hash = self nonEmptyCharacterSet hash
]

{ #category : #tests }
BitmapCharacterSetTest >> testIncludes [
	| set |

	set := self emptyCharacterSet.
	self
		deny: (self characters anySatisfy: [:each | set includes: each]);
		deny: (self absentCharacters anySatisfy: [:each | set includes: each]).

	set addAll: self characters.
	self
		assert: (self characters allSatisfy: [:each | set includes: each]);
		deny: (self absentCharacters anySatisfy: [:each | set includes: each]).
]

{ #category : #tests }
BitmapCharacterSetTest >> testNewFrom [
	| set newSet |

	set := self characterSetClass newFrom: self characters.
	self
		assert: set class == self characterSetClass;
		assert: (self characters allSatisfy: [:each | set includes: each]).

	newSet := self characterSetClass newFrom: set.
	self
		assert: newSet = set;
		deny: newSet == set.
]

{ #category : #tests }
BitmapCharacterSetTest >> testRemoveIfAbsent [
	| set |

	set := self nonEmptyCharacterSet.
	self
		assert: (self absentCharacters allSatisfy: [:each | (set remove: each ifAbsent: [nil]) isNil]);
		assert: (self characters allSatisfy: [:each | (set remove: each ifAbsent: [nil]) = each]);
		deny: (self characters anySatisfy: [:each | set includes: each]);
		assert: (self characters allSatisfy: [:each | (set remove: each ifAbsent: [nil]) isNil]).
]

{ #category : #tests }
BitmapCharacterSetTest >> testSize [
	| set |

	set := self emptyCharacterSet.
	self assert: set size isZero.

	self characters doWithIndex: [:each :i |
		set add: each.
		self assert: set size = i].

	self characters doWithIndex: [:each :i |
		set remove: each.
		self assert: set size = (self characters size - i)].	
]
