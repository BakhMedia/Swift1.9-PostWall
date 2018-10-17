# PostWall
### Урок 9.

В последних уроках мы с вами много занимались визуальной частью, а сегодня мы создадим очень простой экран, но напишем довольно много кода, так как настало время создать чат. В этом уроке мы с вами добавим 2 новых запроса к нашему серверу, посмотрим что такое **Notification** (уведомление по английски) и применим хитрость с клавиатурой. Погнали!


Перейдем к экрану чат. Удалим наше надпись-заглушку. И разместим **Navigation bar** как и на других экранах, напишем в нём Чат. не забудем поменять белый цвет фона так чтоб он совпадал с нашим заголовком. Зададим констрейты нашему заголовку: сверху, слева и справа 0. Далее уже простые вещи для нас.

Разместим **Button** в самом нижнем правом углу, выставим ему констрейты справа 8, снизу тоже 8. А высоту и ширину по 32. Удалим весь текст из него, вместо него поставим заранее нагугленную иконку, которая будет значить отправку сообщения. Найдем в **attributes inspector`e** поле **Image** и внесем туда имя нашего изображения. 


Разместим многострочный **TextView** слева от **Button\`a**. Зададим констрейты слева, снизу и справа 8. По нашей идее сюда участник нашего маленького коммьюнити будет вписывать сообщение, которое захочет отправить. Так же в **attributes inspector`e** найдем раздел **Scroll View**, в нем нас интересует галочка **Scrolling Enabled**, найти и снять! Мы хотим чтоб сообщение не скроллилось, а увеличивалось в высоту автоматом, так что прокрутка нам действительно ни к чему.

Пока у нас нет авторизации пользователь будет сам руками вводить своё имя. Добавим **Text Field** над нашим полем для ввода сообщения и зададим ему следующие констрейты: слева, справа и снизу 8, да, такие же как и прошлого, но у нас получилось пошире, так как кнопка не входит в этот 0. В **attributes inspector`e** найдем параметр **placeholder** и впишем туда слово «Имя». Этот текст будет показываться пользователю пока он не начнет вводить туда что либо.

Остался последний элемент, в который мы будем выводить все наши сообщения. Эту роль на себя возьмёт наш старый знакомый **UITableView**. Разместим его на свободное место экрана и зададим ему констрейты верх, лево, право и низ равными нулю. Рабочее пространство нашего чата занято!

Прежде чем взяться за сам чат, подготовим все необходимые нам файлы. Создадим файл **Message.swift**. В нем будет следующий текст:
``` swift
import UIKit

class Message {

    public var name: String
    public var text: String
    public var creationTime: String

    init(data d: [String:Any]) {
        self.name = d["user_name"] as! String
        self.text = d["text"] as! String

        let secondsSince1970: Int = Int(d["creation_time"] as! String)!
        let creationDate = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.creationTime = formatter.string(from: creationDate)
    }

}
```

Этот файл похож на файл **Feed.swift** не только визуально, но и функцию он будет нести похожую. Напомню какую функцию эти файлы выполняют.  Они считывают (то есть сериализуют) данные пришедшие от сервера и хранят их в себе, чтоб нам было легко с ними работать. Так что я скопирую его содержимое и вставлю в новый файл, поменяю название класса и параметры, не нужное удалю. Так же для сообщений в чате нам интересно видеть не только год, месяц и день, но и час с минутами тоже. Так что добавим в формат времени буквы «HH», означающие часы и «mm» — минуты. Класс **Message** готов, он содержит в себе имя автора сообщения, само сообщение, дату и время отправки. Массив этих переменных мы и будем получать от сервера.


Теперь давайте создадим внешний вид ячейки нашей таблицы, то есть создадим внешний вид отдельно взятого сообщения в чате. Создадим файл **MessageItem.swift**. Добавим в него следующий текст:
``` swift
import UIKit

class MessageItem: UITableViewCell {

}
```

Далее создадим файл **View**, то есть **xib**. Удалим **View** из него и вставим **Table view cell**. Перейдем в **Identity inspector** и в поле **class** укажем наш **MessageItem**. Мы с Вами уже проделывали эту операцию, когда работали с лентой. 

Тут довольная простая работа с внешним видом и констрейтами. Разместим в левый верхний угол изображение, которое в будущем будет выполнять роль аватарки, а пока просто декоративный элемент. Справа от него разместим **Label**, для имени автора сообщения. Еще левее я разместил **Label** для даты и времени отправки, ему зададим серый цвет текста и по вкусу уменьшим шрифт 😜. Под этим всем делом разместим главный **Label**, который будет содержать в себе само сообщение. А теперь единственное отличие от **FeedItem**: обязательно зададим нижний констрейт для этого **Label**. В прошлом уроке мы так же крепили нижний элемент в **ScrollView**. Зачем же здесь так сделали? Запомните этот момент, мы скоро с вами доберемся и я всё поясню.

Создадим связи **MessageItem.xib** и **MessageItem.swift** в **Connections Inspector`e**. Я элементы назвал **nameLabel**, **dateLabel** и **messageTextLabel**, по названиям сразу понятно какая переменная за какой элемент отвечает. Так же добавим функцию, которая будет заполнять эти элементы.

``` swift
public func setMessage(m: Message) {
    nameLabel.text = m.name
    dateLabel.text = m.creationTime
    messageTextLabel.text = m.text
}
```

Даже не знаю нужны ли здесь комментарии. Входящий параметр m типа **Message**, который мы не давно с вами создали. Из него заполняем наши **Label`ы** соответствующими переменными из этого класса. Вроде всё совсем элементарно.

Теперь перейдем в файл **Main.storyboard**. Выберем наш экран Чат. С помощью **Connection Inspector`a** создадим переменные наших элементов в файле **ChatViewController**: **tableView** — для таблицы, **nameField** — для поля «Имя», **messageField** — для сообщения и **sendButton** — для кнопки отправить. Так же выберем **TableView** и создадим связи для **delegate** и **dataSource** как мы делали в уроке с **Лентой**. Но сегодня мы добавим еще один делегат, а именно для нашего **messageField**, перетащим его так же и делегат от таблицы. Нам понадобится создать еще одну связь в **Connection Inspector**: создать событие на нажатие на кнопку. У **sendButton** выберем **Touch Up Inside** и перетащим на свободное место в файле, назовем функцию просто **send**.

Чтож вот мы и закончили приготовления и подошли к главной части этого урока. Мы можем открыть файл **ChatViewController** на весь экран и попрограммировать. Объявим 3 переменных:

``` swift
private var messages: [Message] = []

private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(reload), for: UIControlEvents.valueChanged)
    return refreshControl
}()
```

Разберем их:
- **messages** — массив сообщений, в нем будут хранится сообщения пришедшие нам с сервера;
- **refreshControl** — мы просто скопировали эту переменную с экрана **FeedViewController**, там же мы её рассматривали.
Однако появилась ошибка говорящая нам о том что нет идентификатора **reload**.


Что ж давайте создадим её. По логике эта функция должна запрашивать с сервера список сообщений. Так и есть запрос на сервер мы уже делали, я опять таки просто скопировал его, но поменял пару мест:
- поменялся адрес запроса на **http://triangleye.com/bakh/lessons/swift/s9/messages/**. Именно поэтому адресу мы подготовили для Вас список сообщений. Пользуйтесь, учитесь.
- если в **FeedViewController** мы получили список **feeds** и тип был массив **Feed**, то теперь у нас массив **messages**, а тип переменной — **Message**. 
- ну и имя переменной самого элемента таблицы изменилось на **tableView**
- еще одно изменение. После загрузки с сервера и чтения в массив сообщений мы обновляем **tableView** с помощью функции **reloadData()** и за этим идет новая не знакомая нам строка. Мы у **tableView** вызываем  функцию **scrollToRow**, переведу вам как «сколлить к строке». скроллим мы его к строке (**self.messages.count-1**) то есть к последней строке в таблице. **.bottom** — значит к какой части этой строки мы будем скроллить, можете сами поиграться с этим параметром. Ну и последний параметр **animated** — анимировано скроллить или нет. Я выбрал первый вариант. Для чего нам это надо? Всё просто откройте любой мессенджере у себя на телефоне и вы заметите что в любом разговоре вам показывают последние сообщения, а они находятся внизу. Логично что эти приложения делают так же и перематывают переписку на последние сообщения, ведь так удобнее для вас. 
Вот что получилось в итоге:

``` swift
@objc func reload() {
    DispatchQueue.main.async {
        self.refreshControl.beginRefreshing()
    }
    let url = URL(string: "http://triangleye.com/bakh/lessons/swift/s9/messages/")!
    var request = URLRequest(url: url)
    request.httpMethod = «GET"
    URLSession.shared.dataTask(with: request) {data, response, error in
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        if (error != nil) {
            print("Server error is", error ?? "unknow")
            return
        }
        print("Server returns: ", String(data: data!, encoding: String.Encoding.utf8) ?? "")
        let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
        if let responseJSON = responseJSON as? [Any] {
            print(responseJSON)
            self.messages.removeAll()
            for f in responseJSON {
                self.messages.append(Message(data: f as! [String:Any]))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
            }
        } else {
            print("json error")
        }
    }.resume()
}
```

В функцию **viewDidLoad** добавим следующий код:
``` swift
tableView.addSubview(refreshControl)
reload()
```
Обе строки мы встречаем уже не первый раз. В первой строке добавляем элемент, который показывает, что список обновляется, то есть наш **refreshController**. Прямо как в **FeedViewController**. А во второй — запускаем обновление.

Пора бы уже и вывести полученный массив сообщений. Для этого нам надо **ChatViewController** объявить **UITableViewDelegate\`ом** и **UITableViewDataSource`ом**. Помните как это делается? Сразу возникает ошибка, чтоб её исправить добавим функции для работы с нашей таблицей:

``` swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let nibs : Array = Bundle.main.loadNibNamed("MessageItem", owner: self, options: nil)!
    let cell:MessageItem = nibs[0] as! MessageItem
    cell.setMessage(m: messages[indexPath.row])
    return cell
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    view.endEditing(true)
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
}
```


- первая функция нам уже знакома — просто возвращает **messages.count**. То есть кол-во элементов в таблице.
- вторая так же нам знакома, хоть и выглядит по-прежнему страшно — она определяет как выглядит наша ячейка, загружая её из файла **MessageItem**. А заодно и запускает, написанную нами сегодня функцию **setMessage** в файле **MessageItem** — напомню что эта функция выставит имя автора сообщения, само сообщение и дате его отправки.
- следующая функция описывает, что сделать приложению если кликнули на ячейку таблицы. Всё что мы сделаем это просто закроем клавиатуру, на всякий случай, для удобства пользователя. Бывало такое у вас что на телефоне в вашем любимом мессенджере вы ничаяно касались поля ввода и появлялась клавиатура, которую надо было убрать? К примеру в ранних версия вк и whatsapp по нажатию на сам чат — клавиатура не убиралась, было жутко не удобно. Так что исправим это сразу и дадим нашему **view** команду закончить
- И так вот мы и подошли к самой маленькой функции, но самой интересной и не знакомой нам. Эта функция сообщает таблице какой высоты должна быть ячейка. А так как у нас чат, то каждая ячейка должна быть своего размера в зависимости от количества строк в сообщении. Мы же видим что функция всегда возвращает одно и тоже — **UITableViewAutomaticDimension**. Как же так? Ранее сегодня мы создавали файл **MessageItem.xib**, в котором описывали как будет выглядеть наше конкретное сообщение и я говорил что надо привязать последний элемент к нижней границе как в **ScrollView**. Еще просил вас запомнить этот момент. Вот для чего мы это делали: так же как и в **ScrollView**, создавая элемент, в котором точно и однозначно можно посчитать его высоту — мы можем использовать эту константу, чтоб высота ячейки автоматически высчитывалась. Сняли с себя кучу работы одной константой. Вот такой тонкий момент, о котором даже не все профи знают 😎 и иногда можно увидеть как считают в ручную.


Мы уже можем запустить приложение и увидеть список последних сообщений. Если поиграться, то заметим при появлении клавиатуры поля ввода уплывают как бы «за неё». Что бы исправить это — объявим 3 функции.

``` swift
@objc func scrollToBot(sender: NSNotification) {
    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
}

@objc func keyboardWillShow(sender: NSNotification) {
    let info = sender.userInfo!
    let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    self.view.frame.size.height = UIScreen.main.bounds.height - keyboardFrame.height + 44
}

@objc func keyboardWillHide(sender: NSNotification) {
    self.view.frame.size.height = UIScreen.main.bounds.height
}
```

- Сегодня уже рассказал почему сколлим на последнее сообщение. Эта функция создана именно для этого и будет отрабатывать при появлении клавиатуры.
- Вторая функция будет вызываться когда будет появлсять клавиатура, получает размеры клавиатуры и уменьшает высоту **self.view.frame** на полученное значение. Таким образом мы сохраняе 44 — это стандартная высота нижнего таббара.
- Третья функция — когда клавиатура скрывается. Возвращаем значение равное всему экрану.

Добавим в функцию **viewDidLoad** следующие строки:

``` swift
NotificationCenter.default.addObserver(self, selector: #selector(scrollToBot), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
```

Здесь мы касаемся очень полезного механизма, а именно **NotificationCenter**. В этом центре можно регистрировать **Observer`ов** (наблюдателей) на разные события, мы регистрируемся на 3 события для которых и создавали функции. **UIKeyboardDidChangeFrame** — клавиатура изменилась в размере. **UIKeyboardWillShow** — клавиатура будет показана и **UIKeyboardWillHide** — клавиатура будет скрыта. У этого механизма огромное количество возможностей, все их вы можете почитать в документации эппл, так как у нас просто памяти на карте не хватит их все перечислить [https://developer.apple.com/documentation/foundation/nsnotification/name](https://developer.apple.com/documentation/foundation/nsnotification/name). Подробнее об **NSNotification** смотрите у нас в теоретическом уроке, там мы расскажем просто и доступно.

Осталось только одно — научить наше приложение отправлять сообщения в чат. Для этого мы будем использовать запрос типа **POST**. В функции **send**, которую напомню мы привязали к **Touch Up Inside** на нашей кнопке, напишем следующий код:

``` swift
view.endEditing(true)
if (nameField.text?.isEmpty)! {
    return
}
if messageField.text.isEmpty {
    return
}
sendButton.isEnabled = false
let url = URL(string: "http://triangleye.com/bakh/lessons/swift/s9/sendMessage/")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
let postString = "name=" + nameField.text! + "&message=" + messageField.text
request.httpBody = postString.data(using: String.Encoding.utf8)
URLSession.shared.dataTask(with: request) {data, response, error in
    DispatchQueue.main.async {
        self.messageField.text = ""
        self.sendButton.isEnabled = true
    }
    self.reload()
}.resume()
```

Многое из этого мы уже использовали, но быстро пробежимся чтобы закрепить:
- Останавливаем редактирование, то есть скрываем клавиатуру;
- Проверяем на пустоту оба поля;
- Выключаем кнопку, чтоб пока идет отправка пользователь не посылал на сервер одно и тоже несколько раз;
- Задаем урл куда посылать будем;
- Определяем такие параметры как метод запроса — **POST**, параметры **name** и **message**. И отправляем сам закпрос на сервер.
- Как ответ будет получен, результат нам пока не важен — просто очищаем поле сообщения, включаем кнопку отправки и обновляем список сообщений, чтоб увидеть наше сообщение.

Само собой я не считаю что написал чат, за 20 минут это не реально. Посмотрим что у нас получилось.

![Image1](https://raw.githubusercontent.com/BakhMedia/Swift1.9-PostWall/master/images/1.gif "Image1")


**Сейчас попробуйте по памяти все повторить, желательно 2-3 раза.**






