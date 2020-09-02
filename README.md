This is a simple app that fetches movie details and displays the info. It makes use of MVVM and coordinator pattern.The search logic being used is 
```
    private func searchLogic(title: String, query: String) -> Bool {
        let words = title.split{$0 == " "}.map(String.init)
        let startsWith =  words.contains { (word) -> Bool in
            word.starts(with: query)
        }
        let wordsPresent: Bool = {
            let queryWords = query.split{$0 == " "}.map(String.init)
            let set1:Set<String> = Set(queryWords)
            let set2:Set<String> = Set(words)
            return set1.subtracting(set2).isEmpty
        }()
        return startsWith || wordsPresent
    }
```
one shortcoming of this logic is that, it won't match against the last typing word unless its complete. In this project I could've also added Strategy pattern to add mock sources for network so that I can write unit tests as well.

Also, I've used collection view hear for listing the movie details instead of tableview so that the sample app could use multi column layout and would look pretty on the iPad. Also, this uses the new collectionview diffable datasources, composition layouts.
