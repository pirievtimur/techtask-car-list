## techtask-github-users

# Description

- App returns list of car models from stubbed json data by simulating network request
- New car models save by storage implemented by using CoreData
- Ability to load new cars data which will be appended to existing cars from storage
- Ability to remove all cars from storage
- Tap on car cell expands cell for displaying car owners

# Tech stack

- arch: MVVM
- mapping: ObjectMapper
- reactive: RxSwift & RxCocoa
- storage: CoreData with reactive wrappers(idea from https://github.com/sergdort/CleanArchitectureRxSwift)
