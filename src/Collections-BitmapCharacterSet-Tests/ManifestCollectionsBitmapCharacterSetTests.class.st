"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCollectionsBitmapCharacterSetTests,
	#superclass : #PackageManifest,
	#category : #'Collections-BitmapCharacterSet-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestCollectionsBitmapCharacterSetTests class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#BitmapCharacterSetTest #testIncludesRangeFromTo #false)) #'2023-09-10T10:22:27.072+02:00') )
]

{ #category : #'code-critics' }
ManifestCollectionsBitmapCharacterSetTests class >> ruleEqualsTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#BitmapCharacterSetTest #testRemoveAll #false)) #'2023-09-10T10:23:20.756+02:00') )
]

{ #category : #'code-critics' }
ManifestCollectionsBitmapCharacterSetTests class >> ruleLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMetaclassDefinition #(#'ManifestCollectionsBitmapCharacterSetTests class' #ManifestCollectionsBitmapCharacterSetTests)) #'2023-09-10T10:26:38.422+02:00') )
]

{ #category : #'code-critics' }
ManifestCollectionsBitmapCharacterSetTests class >> ruleUsesAddRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#BitmapCharacterSetTest #testAdd #false)) #'2023-09-10T10:20:40.071+02:00') )
]
