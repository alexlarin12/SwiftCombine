import UIKit
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


