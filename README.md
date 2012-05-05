Rspec - туториал
================

По "горячим" следам решил зафиксировать, что такое *Rspec* http://rspec.info/ .

## Установка

    gem install rspec
    gem install autotest

Устанавливаем сам пакет, и модуль автоматического тестирования.

Rspec - это библиотека, которая позволяет тестировать приложение, выполняя функции
и проверяя ожидаемые значения переменных и т.п.

Например, у нас есть класс "Мяч", для него:
 * экземпляр этого класса, должен быть классом "Мяч", 
 * когда мы присваиваем координаты, то при чтении - мы должны получить те же самые значения
 * мы можем передвигать мяч - вправо, влево, вверх, вниз - и должны изменяться координаты


Подход `rspec` означает:

1. первично пишем сценарии проверки нашей функции,
2. запускаем тест - видим ошибку, и 
3. начинаем реализовывать функции в нашем классе
4. то тех пор пока тест не пройдёт
5. после этого - пишем следующий тест, и заново п.1

## Начнём

создаём папку `rspec-demo`, в ней папку `lib`.

Инициализируем `rspec`:

    rspec --init

Это команда создаст:

  * файл `.rspec` - в котором содержатся конфигурации `rspec`
  * папку `spec` - в которой будут все наши спецификации
  * файл `spec/spec_helper.rb` - это файл "помощник" который подгружается при 
  каждом тестировании в нём можно выполнить необходимые инициализации

### Файл конфигурации `.rspec`

Файл по сути содержит опции запуска rspec команды, то есть можно указать значение
любой опции, у меня содержимо файла было:

    --color
    --format progress

Это означает, что выводить в консоль в цвете (успешно - зелёным, не успешный текст - красным).

И так же определяется форматтер для вывода. Давайте "progress" поменяем на "documentation".

    --color
    --format documentation



### Первый сценарий

Создаём файл (пустой) `lib/ball.rb`, содержимое:

    class Ball
    end

Создаём файл `spec/ball_spec.rb`

Содержимое `ball_spec.rb`:

    require 'spec_helper'
    require 'lib/ball'

    describe Ball do
      it 'instance is class Ball' do
        ball = Ball.new
        ball.class.to_s.should == 'Ball'
      end
    end

После этого находясь в корне нашего приложения `rspec_demo` запускаем тестирование:

    rspec

И получаем в результате:

    Ball
      instance is class Ball

    Finished in 0.01562 seconds
    1 example, 0 failures


### Замечание для win пользователей

Для счастливых обладателей OS Windows - цветовое отображение не будет в цвете - 
так как win не поддерживает ansi символы.

Но для этого есть замечательно решение - `ansicon`.

Цель этого проекта - предоставить для win пользователей поддержку ansi.

Исходный код с readme: https://github.com/adoxa/ansicon

Скачиваем с основного сайта: http://adoxa.110mb.com/ansicon/
По ссылке: http://adoxa.110mb.com/ansicon/dl.php?f=ansicon

Получим zip архив (в моём случае был ansi151.zip), распаковываем, 
выбираем папку соответствующую нашему разряду процессора: x64 (63) или x86 (32)

В ней находится файл `ansicon.exe`, для регистрации в системе запускаем:

    ansicon.exe -i

Для деинсталляции:

    ansicon.exe -u

После этого повторный запуск `rspec` в папке нашего демо проекта `rspec-demo`,
для OS Windows - должен вывести результат в цвете.


### Ожидатели


В нашем примере мы использовали конструкцию `ball.class.to_s.should == 'Ball'`

Здесь `should ==` -- это "EXPECTATIONS" rspec, он говорит, что мы ожидаем, что значение
будет указанное нами.

Список можно увидеть здесь: https://github.com/rspec/rspec-expectations

В нашем примере мы хотели проверить Класс. В списке есть подходящий Expectation для этого:

    actual.should be_an_instance_of(expected)

Поэтому меняем пример, и получаем:

    require 'spec_helper'
    require 'lib/ball'

    describe Ball do
      it 'instance is class Ball' do
        ball = Ball.new
        ball.should be_an_instance_of Ball
      end
    end

После этого запускаем команду `rspec`, и видим, что тест успешно пройден.


### Автотест

Мы запускали тестирование каждый раз когда вносили изменение, 
для автоматизации этого процесса есть замечательный механизм - `autotest`.

Принцип его работы простой - после запуска в папке где есть `.rspec`, и `spec` - 
он находит соответсвие моделей к спецификациям, и при изменении одной из них 
запускает `rspec` тестирование автоматически и выводит на косоль.

Давайте попробуем, в корне демо папку запускаем:

    autotest

Для OS windows пользователей можно - `start autotest` - тогда откроется сразу с отдельном окне.


### Продолжим

Теперь добавим нашу следующу спецификацию

    когда мы присваиваем координаты, то при чтении - 
    мы должны получить те же самые значения

Добавляем в наш файл `spec/ball_spec.rb` следующее (внутри секции `describe Ball do` ... `end`):

    it "store and read x, y" do
      ball = Ball.new :x=>1, :y=>2
      ball.x.should == 1
      ball.y.should == 2
    end

Сохраняем. И видим "чудо" - наш автотест подхватил сохранение - запустил тестирование
и мы видим что наш второй тест не работет.

Пойдём в класс `ball.rb` и добавим конструктор:

    def initialize(options)
      @x = options[:x]
      @y = options[:y]
    end

Сохраняем. И видим интересное - перестали работать оба теста. И в этом есть
самое интересно в тестировании - что когда мы покрываем функционал тестами,
то мы уверены, что когда мы модифицируем что-либо - остальные тесты так же 
проходят.

Ошибка в возникает, что мы не передаём инциализацию, поправим конструктор:

    def initialize(options=nil)
      @x = @y = 0
      if options
        @x = options[:x] 
        @y = options[:y]
      end
    end

Сохраняем - и видим, что наш первый тест - заработал.

Теперь смотрим почему не работает - мы должны сделать "геттеры" для переменных объекта,
для `@x` и для `@y` - добавляем `attr_reader`, получаем:

    class Ball
      attr_reader :x, :y

      def initialize(options=nil)
        @x = @y = 0
        if options
          @x = options[:x] 
          @y = options[:y]
        end
      end
    end

Сохраняем - и видим, что обе наши спецификации - прошли успешно.


## Блоки

Если мы ещё раз посмотрим на формат файла со спецификациями, то мы увидим там блоки: 

    describe "Object" do 
      ... 
    end

Это корневой блок, который говорит о сущности, которую мы описываем.

Внутри этого блока содержатся блоки формата:

    it "description" do
      ...
    end
   
это есть заявленный функционал, который мы тестируем.

Можно группировать набор `it` в блоки "контекст" - 

    context "description" do
      ...
    end

Насколько я понимаю `describe` и `context` выполняют просто группировочную роль - и визуального отображени результатов
тестирования.

Так же обратим внимание, что в нашем примере в блоке `describe` указан не текст, а класс `Ball`:

    describe Ball do
      ...
    end

Что так же допустимо.


## Конфигурирование `autotest`

При изменениях файлов `autotest` - начинает прогонять все тесты. Но иногда есть файлы
изменение которых нет  необходимости отслеживать, например в этом репозитории
это - `README.md`.

Для настройки создаём в корне приложения файл `.autotest` с содержимым:

  Autotest.add_hook(:initialize) {|at|
    at.add_exception %r{^\.git}  # ignore Version Control System
    at.add_exception %r{^./README.md}
    nil
  }

Методом `add_exception` добавили игнорирование папки `.git` и файла `README.md`.

Подробно про `autotest` можно прочитать здесь: https://github.com/rspec/rspec/wiki/autotest 


## Движение Мяча


Добавим новую функцию - move_to(DIRECTION).

Она получает параметр - типа символ, направление движения:

 * :right
 * :left
 * :up
 * :down

И соответственно должны изменяться координаты. Предположим что наши координаты - слева внизу 0,0.

Опишем в `ball_spec.rb` в блоке `describe`:

    context "#move_to" do
      it "direction right - correlate x+1" do
        ball = Ball.new :x=>1, :y=>2
        ball.move_to :right

        ball.x.should == 2
        ball.y.should == 2
      end
    end

Сохраним файл. Если у нас стартовал `autotest` то 
он должен сообщить об одной ошибке, не определён метод `move_to`:


    Failures:

      1) Ball#move_to direction right - correlate x+1
         Failure/Error: ball.move_to :right
         NoMethodError:
           undefined method `move_to' for #<Ball:0x31f4238 @y=2, @x=1>
         # ./spec/ball_spec.rb:20


При этом обратим внимание на составное описание:


    Ball#move_to direction right - correlate x+1


Здесь:

  * `Ball` - основной блок `describe` (название класса)
  * `#move_to` - это блок `context` (наше описание контекста)
  * `direction right - correlate x+1` - это блок `it` (наше описание теста)

Создаём функцию в `ball.rb` в нашем классе Мяча:

    def move_to(direction)
      # TODO
    end


Сохраняем - получаем другую ошибку:

    Failures:

      1) Ball#move_to direction right - correlate x+1
         Failure/Error: ball.x.should == 2
           expected: 2
                got: 1 (using ==)
         # ./spec/ball_spec.rb:22


Которая говорит, что после передвижения направо - мы ожидали координату x равную 2,
но она равна 1.


Добавляем реализацию в `ball.rb`:


    def move_to(direction)
      case direction
        when :right then @x += 1
      end
    end


Сохраняем. И получаем 3 проверки и 0 ошибок.


## Русский язык

Вопрос использования нативного языка при программировании всегда не однозначный. 
Каждый решает сам.

Попробуем описать нашу спецификацию на русском (конечно же utf-8):


    context "#move_to" do
      it "при движении направо увеличивается координата x, но y остётся неизменной" do
        ball = Ball.new :x=>1, :y=>2
        ball.move_to :right

        ball.x.should == 2
        ball.y.should == 2
      end
    end


Сохраняем, и опладательи нормальной консоли - увидят русский текст.

### Windows заметки

Обладатели Windows - увидят:

    Ball
      instance is class Ball
      store and read x, y
      #move_to
        ╨┐╤А╨╕ ╨┤╨▓╨╕╨╢╨╡╨╜╨╕╨╕ ╨╜╨░╨┐╤А╨░╨▓╨╛ ╤Г╨▓╨╡╨╗╨╕╤З╨╕╨▓╨░╨╡╤В╤Б╤П ╨║╨╛╨╛╤А╨┤
    ╨╕╨╜╨░╤В╨░ x, ╨╜╨╛ y ╨╛╤Б╤В╤С╤В╤Б╤П ╨╜╨╡╨╕╨╖╨╝╨╡╨╜╨╜╨╛╨╣

    Finished in 0.01562 seconds
    3 examples, 0 failures


Варианта 3:

  1. переустановить `OS`
  2. писать на английском
  3. пофиксить `rspec`

Попробум п.3

За отображение отвечает гем `rspec-core`, а именно форматтеры, на win машине размещаются здесь:

    C:\Ruby187\lib\ruby\gems\1.8\gems\rspec-core-2.9.0\lib\rspec\core\formatters\


Базовый форматтер в конструкторе получает класс для отображения:

    attr_reader :duration, :examples, :output

    def initialize(output)
      @output = output || StringIO.new
      ...

И далее для вывода текста используется конструкция

    output.puts

См. например в `documentation_formatter.rb`

Благодаря возможностям `Ruby` нам надо понять класс которые используется, 
и переопределить вывод `puts` - конвертировать в `CP866` - тогда будет корректно
отображаться в коносли windows.

В нашем случае для вывода на консоль использутся класс `IO`.

Добавляем код в файл `spec/spec_helper.rb`, перед `RSpec.configure do |config|` блоком:

    # win console utf8
    if RUBY_PLATFORM =~ /mswin32/ || RUBY_PLATFORM =~ /mingw32/
      class IO
        def puts(text=nil)
          require 'iconv'
          text2 = Iconv.iconv('CP866', 'UTF-8', text)
          Kernel::puts text2
        end
      end
    end

Сохраняем, и видим в автотесте:

    Ball
      instance is class Ball
      store and read x, y
      #move_to
        при движении направо увеличивается координата x, но y остётся неизменной


.. TODO ..


# Статьи

 * http://rubydev.ru/2011/09/rspec-tutorial-ruby-rails-bdd/ - RSpec Tutorial: Введение (на русском)


# Видео

Видео иногда может рассказать больше, чем десяток прочитанных страниц )

 * http://www.youtube.com/watch?v=lplAbr9x4Os "How to Integrate rspec into a Sinatra App" - первые 4 минуты показан пример "чистого" Rspec,
 и дальше показан пример тестирвоания Sinatra приложения.


# Примеры

Изучать новое хорошо на примерах. 

Здесь: http://pragprog.com/titles/achbd/source_code

а точнее:

 * http://media.pragprog.com/titles/achbd/code/achbd-code.zip
 * или http://media.pragprog.com/titles/achbd/code/achbd-code.tgz

архив (10Мб) с примерами из классической книги "The RSpec Book: Behaviour-Driven Development with RSpec, Cucumber, and Friends".


# Документация

 * https://www.relishapp.com/rspec/
