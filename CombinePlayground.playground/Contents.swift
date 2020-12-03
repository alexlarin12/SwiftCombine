import UIKit
import Foundation
import Combine



private var subscriptions = Set<AnyCancellable>()

public func example(of description: String, action: () -> Void) {
  print("\n------ Example of:", description, "------")
  action()
}


example(of: "HomeWork: Lesson 2: part 1") {
    let count = 50
    // коллекция чисел от 1 до 100:
    let numbers = (1...100).publisher
    numbers
        //Пропускаем первые 50 значений, выданных вышестоящим издателем:
        .dropFirst(count)
        //Берем следующие 20 значений после этих 50:
        .prefix(while: { $0 <= (count + 20)})
        //Оставляем только четные из этих 20:
        .filter { ($0 % 2) == 0}
        //Буферизация потока в массив значений:
        .collect()
        .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
        .store(in: &subscriptions)
}
example(of: "HomeWork: Lesson 2: part 2") {
    var sumNumber = 0
    // создали форматтер:
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    // создали издателя целых строк:
    let strings = ["one", "two", "three", "seven"].publisher
    strings
        // используем map для преобразования слов в цифры
        .map {
            formatter.number(from: String( $0 )) ?? 0
        }
        // буферизация потока в массив значений:
        .collect()
        .sink(receiveValue: { arrayInt in
            arrayInt.forEach { number in
                // складываем все числа массива:
                sumNumber = (sumNumber + number.intValue)
            }
            // выводим среднее арифметическое значение
            print(" Среднее арифметическое значение: \(sumNumber / arrayInt.count)")
        })
        .store(in: &subscriptions)
}
/*
public struct Chatter {
  public let name: String
  public let message: CurrentValueSubject<String, Never>
  
  public init(name: String, message: String) {
    self.name = name
    self.message = CurrentValueSubject(message)
  }
}

example(of: "flatMap") {
   // 1. Создали два примера разговора
   let charlotte = Chatter(name: "Charlotte", message: "Hi, I'm Charlotte!")
   let james = Chatter(name: "James", message: "Hi, I'm James!")

   // 2. Создали издателя сообщений, инициализированного с Charlotte
   let chat = CurrentValueSubject<Chatter, Never>(charlotte)

   // 3. Подписались на чат и печатаем полученные сообщения из разговоров
   chat
      .flatMap(maxPublishers: .max(2)) { $0.message }
      .sink(receiveValue: { print($0) })
      .store(in: &subscriptions)
    
    // 4 меняем сообщение у Шарлотты
    charlotte.message.value = "Charlotte: How's it going?"
    // 5 меняем значение у publisher на Джеймс
    chat.value = james
    
    james.message.value = "James: Doing great. You?"
    charlotte.message.value = "Charlotte: I'm doing fine thanks."
}
example(of: "replaceNil") {
   // 1. Создали массив элементов типа Optional<String>
   ["A", nil, "C"].publisher
    .replaceNil(with: "-")
   // 2. Используем оператор для замены всех nil на “-”
   .sink(receiveValue: { print($0) })
   // 3. Выводим каждое значение в консоль
   .store(in: &subscriptions)
}

["A", nil, "C"].publisher
   .replaceNil(with: "-")
   .map { $0! }
   .sink(receiveValue: { print($0) })
   .store(in: &subscriptions)

example(of: "scan") {
   var dailyGainLoss: Int { .random(in: -10...10) }
   let days = (0..<15) .map { _ in dailyGainLoss } .publisher

   days
      .scan(50) { latest, current in
         max(0, latest + current)
      }
      .sink(receiveValue: { _ in })
      .store(in: &subscriptions)
}

example(of: "filter") {
   let numbers = (100...200).publisher
   numbers
   
      .filter { $0 % 3 == 0 }
    
      .sink(receiveValue: { n in
           print("\(n) is a multiple of 3!")
      })
      
      .store(in: &subscriptions)
}

example(of: "prepend(Output...)") {
   let publisher = [3, 4].publisher

   publisher
      .prepend(1, 2)
      .prepend(-1,0)
      .sink(receiveValue: { print($0) })
      .store(in: &subscriptions)
}

example(of: "prepend(Sequence)") {

let publisher = [5, 6, 7].publisher
publisher
   .prepend([3, 4])
   .prepend(Set(1...2))
   .sink(receiveValue: { print($0) })
   .store(in: &subscriptions)


}

example(of: "prepend(Publisher)") {

let publisher1 = [3, 4].publisher
let publisher2 = [1, 2].publisher
publisher1
   .prepend(publisher2)
   .sink(receiveValue: { print($0) })
   .store(in: &subscriptions)


}
*/
example(of: "prepend(Publisher) #2") {

let publisher1 = [3, 4].publisher
let publisher2 = PassthroughSubject<Int, Never>()

publisher1
   .prepend(publisher2)
   .sink(receiveValue: { print($0) })
   .store(in: &subscriptions)


publisher2.send(1)
publisher2.send(2)

   
    publisher2.send(completion: .finished)
}
/*
example(of: "switchToLatest") {

   let publisher1 = PassthroughSubject<Int, Never>()
   let publisher2 = PassthroughSubject<Int, Never>()
   let publisher3 = PassthroughSubject<Int, Never>()
   let publishers = PassthroughSubject<PassthroughSubject<Int,Never>, Never>()


   publishers
      .switchToLatest()
      .sink(receiveCompletion: { _ in print("Completed!") },
            receiveValue: { print($0) })
      .store(in: &subscriptions)


   publishers.send(publisher1)
   publisher1.send(1)
   publisher1.send(2)
   publishers.send(publisher2)
   publisher1.send(3)
   publisher2.send(4)
   publisher2.send(5)
   publishers.send(publisher3)
   publisher2.send(6)
   publisher3.send(7)
   publisher3.send(8)
   publisher3.send(9)
   publisher3.send(completion: .finished)
   publishers.send(completion: .finished)
}

example(of: "switchToLatest - Network Request") {
   let url = URL(string: "https://source.unsplash.com/random")!
   
   func getImage() -> AnyPublisher<UIImage?, Never> {
      return URLSession.shared
                  .dataTaskPublisher(for: url)
                  .map { data, _ in UIImage(data: data) }
                  .print("image")
                  .replaceError(with: nil)
                  .eraseToAnyPublisher()
   }

   let taps = PassthroughSubject<Void, Never>()
   taps
      .map { _ in getImage() }
      .switchToLatest()
      .sink(receiveValue: { _ in })
      .store(in: &subscriptions)


   taps.send()
   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      taps.send()
   }
   DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
      taps.send()
   }
}

example(of: "merge(with:)") {

   let publisher1 = PassthroughSubject<Int, Never>()
   let publisher2 = PassthroughSubject<Int, Never>()


   publisher1
      .merge(with: publisher2)
      .sink(receiveCompletion: { _ in print("Completed") },
            receiveValue: { print($0) })
      .store(in: &subscriptions)
   
   publisher1.send(1)
   publisher1.send(2)
   publisher2.send(3)
   publisher1.send(4)
   publisher2.send(5)
   publisher1.send(completion: .finished)
   publisher2.send(completion: .finished)
}

example(of: "combineLatest") {


   let publisher1 = PassthroughSubject<Int, Never>()
   let publisher2 = PassthroughSubject<String, Never>()


   publisher1
      .combineLatest(publisher2)
      .sink(receiveCompletion: { _ in print("Completed") },
            receiveValue: { print("P1: \($0), P2: \($1)") })
      .store(in: &subscriptions)


   publisher1.send(1)
   publisher1.send(2)
   publisher2.send("a")
   publisher2.send("b")
   publisher1.send(3)
   publisher2.send("c")
   publisher1.send(completion: .finished)
   publisher2.send(completion: .finished)
}
*/
/*
let queue = DispatchQueue(label: "Collect")
let passSubj = PassthroughSubject<Int, Error>()

let subscription = passSubj
    .collect(.byTime(queue, .seconds(1.0)))
    .sink(receiveCompletion: { completion in
        print("received the completion", String(describing: completion))
    }, receiveValue: { responseValue in
        print(responseValue)
    })

queue.asyncAfter(deadline: .now() + 0.1, execute: {
    passSubj.send(1)
})
queue.asyncAfter(deadline: .now() + 0.2, execute: {
    passSubj.send(2)
})
queue.asyncAfter(deadline: .now() + 1, execute: {
    passSubj.send(3)
})
queue.asyncAfter(deadline: .now() + 3.1, execute: {
    passSubj.send(4)
})
queue.asyncAfter(deadline: .now() + 3.2, execute: {
    passSubj.send(5)
})
*/
/*

print("---Collect---")
let queue = DispatchQueue(label: "Collect")
let passSubj = PassthroughSubject<Int, Error>()
let collectMaxCount = 4

let subscription = passSubj
    .collect(.byTimeOrCount(queue, .seconds(1.0), collectMaxCount))
    .sink(receiveCompletion: { completion in
        print("received the completion", String(describing: completion))
    }, receiveValue: { responseValue in
        print(responseValue)
    })

queue.asyncAfter(deadline: .now() + 0.1, execute: {
    passSubj.send(1)
})
queue.asyncAfter(deadline: .now() + 0.2, execute: {
    passSubj.send(2)
})
queue.asyncAfter(deadline: .now() + 0.3, execute: {
    passSubj.send(3)
})
queue.asyncAfter(deadline: .now() + 0.4, execute: {
    passSubj.send(4)
})
queue.asyncAfter(deadline: .now() + 0.5, execute: {
    passSubj.send(5)
})

example(of: "output(at:)") {
let publisher = ["A", "B", "C"].publisher


publisher
   .print("publisher")
   .output(at: 1)
   .sink(receiveValue: { print("Value at index 1 is \($0)") })
   .store(in: &subscriptions)
}
 */


example(of: "Lesson3"){
    
    let queue = DispatchQueue(label: "Collect")
    let pablisher1 = PassthroughSubject<String, Never>()
    let pablisher2 = PassthroughSubject<String, Never>()
    func fromScalarToCharArray(stringScalar :String.UnicodeScalarView) -> [UnicodeScalar]{
        var charsArray:[UnicodeScalar] = []
        stringScalar.forEach{ char in
            charsArray.append(char)
        }
        return charsArray
    }
    func from2DArrayToArray (array: [UnicodeScalar]) {
        var string: UnicodeScalar = " "
        array.forEach { element in
            
            
        }
    }
    pablisher1
        .map {
            $0.unicodeScalars
        }
        .map {
            fromScalarToCharArray(stringScalar: $0)
            
        }
        .map {
            from2DArrayToArray(array: $0)
        }
        .collect(.byTime(queue, .seconds(0.5)))
        .sink(receiveValue: {print($0)})
        .store(in: &subscriptions)
    queue.asyncAfter(deadline: .now() + 0.1, execute: {
        pablisher1.send("Hello")
    })
    queue.asyncAfter(deadline: .now() + 0.2, execute: {
        pablisher1.send("World")
    })
    queue.asyncAfter(deadline: .now() + 0.3, execute: {
        pablisher1.send("Have")
    })
    queue.asyncAfter(deadline: .now() + 0.6, execute: {
        pablisher1.send("a good")
    })
    queue.asyncAfter(deadline: .now() + 0.7, execute: {
        pablisher1.send("day")
    })}

