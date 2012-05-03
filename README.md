Rspec - демо
============

По "горячим" следам решил зафиксировать, что такое Rspec.

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


Подход rspec означает:

1. первично пишем сценарии проверки нашей функции,
2. запускаем тест - видим ошибку, и 
3. начинаем реализовывать функции в нашем классе
4. то тех пор пока тест не пройдёт
5. после этого - пишем следующий тест, и заново п.1

## Начнём

создаём папку "rspec-demo", в ней папку "lib".

Инициализируем rspec:

  rspec --init

Это команда создаст:

  * файл `.rspec` - в котором содержатся конфигурации `rspec`
  * папку `spec` - в которой будут все наши спецификации
  * файл `spec/spec_helper.rb` - это файл "помощник" который подгружается при 
  каждом тестировании в нём можно выполнить необходимые инициализации

### Файл конфигурации .rspec

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

Но для этого есть замечательно решение - ansicon.

Цель этого проекта - предоставить для win пользователей поддержку ansi.

Исходный код с readme: https://github.com/adoxa/ansicon

Скачиваем с основного сайта: http://adoxa.110mb.com/ansicon/
По ссылке: http://adoxa.110mb.com/ansicon/dl.php?f=ansicon

Получим zip архив (в моём случае был ansi151.zip), распаковываем, 
выбираем папку соответствующую нашему разряду процессора: x64 (63) или x86 (32)

В ней находится файл ansicon.exe, для регистрации в системе запускаем:

  ansicon.exe -i

Для деинсталляции:

  ansicon.exe -u

После этого повторный запуск rspec в папке нашего демо проекта `rspec-demo`,
для OS Windows - должен вывести результат в цвете.


### Ожидатели


В нашем примере мы использовали конструкцию `ball.class.to_s.should == 'Ball'`

Здесь `should ==` -- это "EXPECTATIONS" rspec, он говорит, что мы ожидаем, что значение
будет указанное нами.

Список можно увидеть здесь: https://github.com/rspec/rspec-expectations

В нашем примере мы хотели проверить, класс. В списке есть подходящий нам:

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

Принцип его работы простой - после запуска в папке где есть .rspec, и spec - 
он находит соответсвие моделей к спецификациям, и при изменении одной из них 
запускает `rspec` тестирование автоматически и выводит на косоль.

Давайте попробуем, в корне демо папку запускаем:

  autotest

Для OS windows пользователей можно - `start autotest` - тогда откроется сразу с отдельном окне.

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
для @x и для @y - добавляем `attr_reader`, получаем:

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

TODO