"
A baseline for https://github.com/pharo-contributions/BitmapCharacterSet
"
Class {
	#name : #BaselineOfBitmapCharacterSet,
	#superclass : #BaselineOf,
	#category : #BaselineOfBitmapCharacterSet
}

{ #category : #baselines }
BaselineOfBitmapCharacterSet >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		"Packages and Dependencies"
		spec 
			package: 'Collections-BitmapCharacterSet';
			package: 'Collections-BitmapCharacterSet-Tests' with: [ spec requires: 'Collections-BitmapCharacterSet' ].
			
		"Groups"	
		spec				
				group: 'Core' with: #('Collections-BitmapCharacterSet');
				group: 'Tests' with: #('Collections-BitmapCharacterSet-Tests');
				group: 'all' with: #('Core' 'Tests');
				group: 'default' with: #('all')	
	]
]
