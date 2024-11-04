package renovate

#UpdateType: "minor" | "patch" | "pin" | "digest" | "replacement"
#DepType:    "*" | "indirect"
#Manager:    "gomod"

#PackageRule: {
	rangeStrategy?: string
	ignoreTests?:   bool
	matchDepTypes?: [...#DepType]
	matchManagers?: [...#Manager]
	matchUpdateTypes?: [...#UpdateType]
	enabled?:           bool
	automerge?:         bool
	automergeType?:     string
	automergeStrategy?: string
	recreateWhen?:      string
}

#RenovateConfig: {
	"$schema": "https://docs.renovatebot.com/renovate-schema.json"
	extends?: [...string]
	prHourlyLimit:     0
	prConcurrentLimit: 0
	packageRules: [...#PackageRule]
	ignorePaths?: [...string]
	postUpdateOptions?: [...string]
	platformAutomerge: true
}

let basePackageRule = {
	matchDepTypes: ["indirect"]
	enabled: true
	matchManagers: ["gomod"]
}

let automergeBase = {
	automerge: true
}

let noTestCasesBase = {
	ignoreTests:       true
	automergeType:     "branch"
	automergeStrategy: "merge-commit"
}

let updateTypes = {
	standard: ["minor", "patch", "pin", "digest"]
	withReplacement: ["minor", "patch", "pin", "digest", "replacement"]
}

let goPostUpdateOptions = [
	"gomodTidyE",
	"gomodMassage",
	"gomodUpdateImportPaths",
]

let bestPracticesBase = {
	extends: [
		"config:best-practices",
		":dependencyDashboard",
	]
}

let recommendedBase = {
	extends: [
		"config:recommended",
		":dependencyDashboard",
	]
}

cat: #RenovateConfig & bestPracticesBase & {
	packageRules: [
		automergeBase & noTestCasesBase & {
			rangeStrategy: "pin"
			matchDepTypes: ["*"]
			matchUpdateTypes: updateTypes.standard
		},
	]
}

dog: #RenovateConfig & bestPracticesBase & {
	packageRules: [
		automergeBase & {
			matchUpdateTypes: updateTypes.standard
			recreateWhen:     "always"
		},
	]
	postUpdateOptions: goPostUpdateOptions
}

owl: #RenovateConfig & bestPracticesBase & {
	packageRules: [
		automergeBase & {
			matchUpdateTypes: updateTypes.withReplacement
			recreateWhen:     "always"
		},
	]
	postUpdateOptions: goPostUpdateOptions
	ignorePaths: ["**/testdata/go.mod"]
}

monkey: #RenovateConfig & bestPracticesBase & {
	packageRules: [
		basePackageRule,
		automergeBase & noTestCasesBase & {
			matchDepTypes: ["*"]
			matchUpdateTypes: updateTypes.withReplacement
		},
	]
	postUpdateOptions: goPostUpdateOptions
}

hamster: #RenovateConfig & recommendedBase & {
	packageRules: [
		automergeBase & {
			matchDepTypes: ["*"]
			matchUpdateTypes:  updateTypes.standard
			automergeStrategy: "squash"
		},
	]
	postUpdateOptions: goPostUpdateOptions
}
