
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РольДоступнаДобавлениеИзменениеОбменовДанными = ОбменДаннымиСервер.ЕстьПраваНаАдминистрированиеОбменов();
	Если Не РольДоступнаДобавлениеИзменениеОбменовДанными Тогда
		Элементы.СписокСостоянияУзловИзменитьУзелИнформационнойБазы.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Пользователи.РолиДоступны("АдминистраторСистемы") Тогда
		Элементы.СоставОтправляемыхДанных.Видимость = Ложь;
		Элементы.СписокСостоянияУзловСоставОтправляемыхДанных.Видимость = Ложь;
		Элементы.СписокСостоянияУзловКонтекстноеМенюСоставОтправляемыхДанных.Видимость = Ложь;
		Элементы.УдалитьНастройкуСинхронизации.Видимость = Ложь;
		Элементы.СписокСостоянияУзловУдалитьНастройкуСинхронизации.Видимость = Ложь;
	КонецЕсли;
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.СписокПлановОбменаБСП();
	Если СписокПлановОбмена.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Возможность настройки синхронизации данных не предусмотрена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Если РольДоступнаДобавлениеИзменениеОбменовДанными Тогда
		ДобавитьКомандыСозданияНовогоОбмена();
	Иначе
		Элементы.ГруппаНастройкаСинхронизации.Видимость = Ложь;
		Элементы.ИнформационнаяНадпись.ТекущаяСтраница = Элементы.НетПравНаСинхронизацию;
		Элементы.ГруппаСценарииСинхронизации.Видимость = Ложь;
		Элементы.ГруппаНастройкиСинхронизации.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьСписокСостоянияУзлов();
	
	Если Не РольДоступнаДобавлениеИзменениеОбменовДанными Или ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Элементы.ПрефиксСинхронизацияНеНастроена.Видимость = Ложь;
		Элементы.ПрефиксОднаСинхронизация.Видимость = Ложь;
		Элементы.ПрефиксИБ.Видимость = Ложь;
		
	Иначе
		
		ПрефиксИБ = ОбменДаннымиСервер.ПрефиксИнформационнойБазы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьДанныеМонитора", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если    ИмяСобытия = "ВыполненОбменДанными"
		ИЛИ ИмяСобытия = "Запись_СценарииОбменовДанными"
		ИЛИ ИмяСобытия = "Запись_УзелПланаОбмена"
		ИЛИ ИмяСобытия = "ЗакрытаФормаПомощникаСопоставленияОбъектов"
		ИЛИ ИмяСобытия = "ЗакрытаФормаПомощникаСозданияОбменаДанными"
		ИЛИ ИмяСобытия = "ЗакрытаФормаРезультатовОбменаДанными" Тогда
		
		// обновляем данные монитора
		ОбновитьДанныеМонитора();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокСостоянияУзлов

&НаКлиенте
Процедура СписокСостоянияУзловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СписокСостоянияУзловВыборЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Выполнить синхронизацию данных?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСостоянияУзловВыборЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		АвтоматическаяСинхронизация = (Элементы.СписокСостоянияУзлов.ТекущиеДанные.ВариантОбменаДанными = "Синхронизация");
		
		Получатель = Элементы.СписокСостоянияУзлов.ТекущиеДанные.УзелИнформационнойБазы;
		
		ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(Получатель, ЭтотОбъект,, АвтоматическаяСинхронизация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСостоянияУзловПриАктивизацииСтроки(Элемент)
	
	ЗаданыТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные <> Неопределено;
	
	// Командная панель.
	Элементы.Настройка.Доступность = ЗаданыТекущиеДанные;
	Элементы.ГруппаКоманднойПанелиИзменениеИСостав.Доступность = ЗаданыТекущиеДанные;
	Элементы.СписокСостоянияУзловГруппаКнопокВыполненияОбменаДанными.Доступность = ЗаданыТекущиеДанные;
	Элементы.НастроитьРасписаниеВыполненияОбмена.Доступность = ЗаданыТекущиеДанные;
	Элементы.СписокСостоянияУзловЗагрузитьПравилаСинхронизацииДанных.Доступность = ЗаданыТекущиеДанные;
	Элементы.СписокСостоянияУзловИнформацияПоОбмену.Доступность = ЗаданыТекущиеДанные;
	Элементы.СписокСостоянияУзловУдалитьНастройкуСинхронизации.Доступность = ЗаданыТекущиеДанные;
	
	// Контекстное меню.
	Элементы.ГруппаКнопокВыполненияОбменаДанными.Доступность = ЗаданыТекущиеДанные;
	Элементы.КонтекстноеМенюСписокИзменениеИСостав.Доступность = ЗаданыТекущиеДанные;
	Элементы.КонтекстноеМенюСписокСостоянияДиагностика.Доступность = ЗаданыТекущиеДанные;
	Элементы.ГруппаКнопокНастройкиРасписания.Доступность = ЗаданыТекущиеДанные;
	Элементы.СписокСостоянияУзловКонтекстноеМенюИнформацияПоОбмену.Доступность = ЗаданыТекущиеДанные;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбменДанными(Команда)
	
	ОбновитьДанныеМонитора();
	
	ТекущиеДанные = ?(КоличествоСинхронизаций = 1, СписокСостоянияУзлов[0], Элементы.СписокСостоянияУзлов.ТекущиеДанные);
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УзелОбмена", УзелОбмена);
	ДополнительныеПараметры.Вставить("АвтоматическаяСинхронизация", (ТекущиеДанные.ВариантОбменаДанными = "Синхронизация"));
	ДополнительныеПараметры.Вставить("ИнтерактивнаяОтправка", Ложь);
	
	ОписаниеПродолжения = Новый ОписаниеОповещения("ПродолжитьВыполнениеСинхронизации", ЭтотОбъект, ДополнительныеПараметры);
	ПроверитьСовместимостьПравилКонвертации(УзелОбмена, ОписаниеПродолжения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменДаннымиИнтерактивно(Команда)
	
	ТекущиеДанные = ?(КоличествоСинхронизаций = 1, СписокСостоянияУзлов[0], Элементы.СписокСостоянияУзлов.ТекущиеДанные);
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УзелОбмена", УзелОбмена);
	ДополнительныеПараметры.Вставить("ИнтерактивнаяОтправка", Истина);
	
	ОписаниеПродолжения = Новый ОписаниеОповещения("ПродолжитьВыполнениеСинхронизации", ЭтотОбъект, ДополнительныеПараметры);
	
	ПроверитьСовместимостьПравилКонвертации(УзелОбмена, ОписаниеПродолжения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСценарииОбменаДанными(Команда)
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ОбработкаКомандыНастроитьРасписаниеВыполненияОбмена(ТекущиеДанные.УзелИнформационнойБазы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьМонитор(Команда)
	
	ОбновитьДанныеМонитора();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьУзелИнформационнойБазы(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ПоказатьЗначение(, УзелОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийЗагрузкиДанных(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(УзелОбмена, ЭтотОбъект, "ЗагрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийВыгрузкиДанных(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(УзелОбмена, ЭтотОбъект, "ВыгрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникНастройкиОбменаДанными(Команда)
	
	ОбменДаннымиКлиент.ОткрытьПомощникНастройкиОбменаДанными(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбновление(Команда)
	ОбменДаннымиКлиент.УстановитьОбновлениеКонфигурации();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСценарииОбменаДаннымиОдна(Команда)
	
	УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
	
	СценарийСинхронизации = СценарийСинхронизацииПоУзлу(УзелОбмена);
	ПараметрыФормы = Новый Структура;
	
	Если СценарийСинхронизации = Неопределено Тогда
		
		ПараметрыФормы.Вставить("УзелИнформационнойБазы", УзелОбмена);
		
	Иначе
		
		ПараметрыФормы.Вставить("Ключ", СценарийСинхронизации);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СценарииОбменовДанными.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьУспешные(Команда)
	
	СкрыватьУспешные = Не СкрыватьУспешные;
	
	Элементы.СписокСостоянияУзловСкрыватьУспешные.Пометка = СкрыватьУспешные;
	
	ОбновитьСписокСостоянияУзлов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияПоОбмену(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	СсылкаНаПодробноеОписание = ПодробнаяИнформацияНаСервере(УзелОбмена);
	
	ОбменДаннымиКлиент.ОткрытьПодробноеОписаниеСинхронизации(СсылкаНаПодробноеОписание);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРезультатыОднаСинхронизация(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзлыОбмена", МассивИспользуемыхУзлов(СписокСостоянияУзлов));
	ОткрытьФорму("РегистрСведений.РезультатыОбменаДанными.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставОтправляемыхДанных(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ОткрытьСоставОтправляемыхДанных(УзелОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкуСинхронизации(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.УдалитьНастройкуСинхронизации(УзелОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПравилаСинхронизацииДанных(Команда)
	
	ТекущиеДанные = ?(КоличествоСинхронизаций = 1, СписокСостоянияУзлов[0], Элементы.СписокСостоянияУзлов.ТекущиеДанные);
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
	
	СведенияОПланеОбмена = СведенияОПланеОбмена(УзелОбмена);
	
	Если СведенияОПланеОбмена.ИспользуютсяПравилаКонвертации Тогда
		ОбменДаннымиКлиент.ЗагрузитьПравилаСинхронизацииДанных(СведенияОПланеОбмена.ИмяПланаОбмена);
	Иначе
		ВидПравил = ПредопределенноеЗначение("Перечисление.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов");
		
		Отбор              = Новый Структура("ИмяПланаОбмена, ВидПравил", СведенияОПланеОбмена.ИмяПланаОбмена, ВидПравил);
		ЗначенияЗаполнения = Новый Структура("ИмяПланаОбмена, ВидПравил", СведенияОПланеОбмена.ИмяПланаОбмена, ВидПравил);
		ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "ПравилаДляОбменаДанными", 
			УзелОбмена, "ПравилаРегистрацииОбъектов");
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция СведенияОПланеОбмена(Знач УзелИнформационнойБазы)
	
	Результат = Новый Структура("ИмяПланаОбмена,ИспользуютсяПравилаКонвертации");
	Результат.ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы);
	Результат.ИспользуютсяПравилаКонвертации = ОбменДаннымиПовтИсп.ЕстьМакетПланаОбмена(Результат.ИмяПланаОбмена, "ПравилаОбмена");
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьДанныеМонитора()
	
	ИндексСтрокиСписокСостоянияУзлов = ПолучитьТекущийИндексСтроки("СписокСостоянияУзлов");
	
	// Выполняем обновление таблиц монитора на сервере.
	ОбновитьСписокСостоянияУзлов();
	
	// Выполняем позиционирование курсора.
	ВыполнитьПозиционированиеКурсора("СписокСостоянияУзлов", ИндексСтрокиСписокСостоянияУзлов);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСостоянияУзлов(ТолькоОбновлениеСписка = Ложь)
	
	ПланыОбменаБСП = ОбменДаннымиПовтИсп.ПланыОбменаБСП();
	
	// Обновляем данные в списке состояния узлов.
	СписокСостоянияУзлов.Загрузить(ОбменДаннымиСервер.ТаблицаМонитораОбменаДанными(ПланыОбменаБСП, "Код", СкрыватьУспешные));
	
	КоличествоНастроенныхОбменов = ОбменДаннымиСервер.КоличествоНастроенныхОбменов(ПланыОбменаБСП);
	
	Если Не ТолькоОбновлениеСписка Тогда
		
		ПроверитьСостояниеОбменаСГлавнымУзлом();
		
		Если КоличествоСинхронизаций <> КоличествоНастроенныхОбменов Тогда
			
			ОбновитьКоличествоСинхронизаций(КоличествоНастроенныхОбменов);
			
		ИначеЕсли КоличествоСинхронизаций = 1 Тогда
			
			УстановитьЭлементыОднойСинхронизации();
			
		КонецЕсли;
		
		ОбновитьКомандыРезультатовСинхронизации();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличествоСинхронизаций(КоличествоНастроенныхОбменов)
	
	КоличествоСинхронизаций = КоличествоНастроенныхОбменов;
	ПанельСинхронизации = Элементы.СинхронизацияДанных;
	ЕстьПравоОбновления = ПравоДоступа("ОбновлениеКонфигурацииБазыДанных", Метаданные);
	
	Если КоличествоСинхронизаций = 0 Тогда
		
		ПанельСинхронизации.ТекущаяСтраница = ПанельСинхронизации.ПодчиненныеЭлементы.СинхронизацияНеНастроена;
		Заголовок = НСтр("ru = 'Синхронизация данных'");
		
		Если РольДоступнаДобавлениеИзменениеОбменовДанными Тогда
			Элементы.Переместить(Элементы.ПодменюСоздать, Элементы.ПанельСоздатьСинхронизацияНеНастроена);
		КонецЕсли;
		
	ИначеЕсли КоличествоСинхронизаций = 1 Тогда
		
		Элементы.ПравоОбновленияСтраницы.ТекущаяСтраница = ?(ЕстьПравоОбновления, 
			Элементы.ПравоОбновленияСтраницы.ПодчиненныеЭлементы.ИнформацияОбменДаннымиПриостановленЕстьПравоОбновления1,
			Элементы.ПравоОбновленияСтраницы.ПодчиненныеЭлементы.ИнформацияОбменДаннымиПриостановленНетПраваОбновления1);
			
		УстановитьЭлементыОднойСинхронизации();
		
		Если РольДоступнаДобавлениеИзменениеОбменовДанными Тогда
			Элементы.Переместить(Элементы.ПодменюСоздать, Элементы.ПанельСоздатьСинхронизацияОдна, Элементы.УдалитьНастройкуСинхронизации);
		КонецЕсли;
		
		ПанельСинхронизации.ТекущаяСтраница = ПанельСинхронизации.ПодчиненныеЭлементы.ОднаСинхронизация;
		
	Иначе
		
		ПанельСинхронизации.ТекущаяСтраница = ПанельСинхронизации.ПодчиненныеЭлементы.НесколькоСинхронизаций;
		Заголовок = НСтр("ru = 'Список настроенных синхронизаций данных'");
		
		Элементы.СписокСостоянияУзловИзменитьУзелИнформационнойБазы.Видимость = РольДоступнаДобавлениеИзменениеОбменовДанными;
		Элементы.НастроитьРасписаниеВыполненияОбмена.Видимость = РольДоступнаДобавлениеИзменениеОбменовДанными;
		Элементы.НастроитьРасписаниеВыполненияОбмена1.Видимость = РольДоступнаДобавлениеИзменениеОбменовДанными;
		
		Элементы.ИнформацияОбменДаннымиПриостановленЕстьПравоОбновления.Видимость = ЕстьПравоОбновления;
		Элементы.ИнформацияОбменДаннымиПриостановленНетПраваОбновления.Видимость = Не ЕстьПравоОбновления;
		
		НадписьОбменДаннымиПриостановлен = ?(ЕстьПравоОбновления,
		Элементы.НадписьОбменДаннымиПриостановленЕстьПравоОбновления,
		Элементы.НадписьОбменДаннымиПриостановленНетПраваОбновления);
		
		НадписьОбменДаннымиПриостановлен.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НадписьОбменДаннымиПриостановлен.Заголовок, ОбменДаннымиСервер.ГлавныйУзел());
		
		Если РольДоступнаДобавлениеИзменениеОбменовДанными Тогда
			Элементы.Переместить(Элементы.ПодменюСоздать, Элементы.КоманднаяПанель, Элементы.СписокСостоянияУзловГруппаКнопокВыполненияОбменаДанными);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыРезультатовСинхронизации()
	
	Если КоличествоСинхронизаций <> 0 Тогда
		
		СтруктураЗаголовка = ОбменДаннымиСервер.СтруктураЗаголовкаГиперссылкиМонитораПроблем(МассивИспользуемыхУзлов(СписокСостоянияУзлов));
		
		Если КоличествоСинхронизаций = 1 Тогда
			
			ЗаполнитьЗначенияСвойств(Элементы.ОткрытьРезультатыОднаСинхронизация, СтруктураЗаголовка);
			
		ИначеЕсли КоличествоСинхронизаций > 1 Тогда
			
			ЗаполнитьЗначенияСвойств(Элементы.ОткрытьРезультатыСинхронизацииДанных, СтруктураЗаголовка);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивИспользуемыхУзлов(СписокСостоянияУзлов)
	
	УзлыОбмена = Новый Массив;
	
	Для Каждого СтрокаУзла Из СписокСостоянияУзлов Цикл
		УзлыОбмена.Добавить(СтрокаУзла.УзелИнформационнойБазы);
	КонецЦикла;
	
	Возврат УзлыОбмена;
	
КонецФункции

&НаСервере
Процедура УстановитьЭлементыОднойСинхронизации()
	
	НастроеннаяСинхронизация = СписокСостоянияУзлов[0];
	
	Если НастроеннаяСинхронизация.УзелИнформационнойБазы = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru = 'Работа монитора синхронизации данных в неразделенном сеансе не поддерживается'");
		
	КонецЕсли;
	
	Элементы.СтраницаРасписание.Картинка = ?(НастроеннаяСинхронизация.РасписаниеНастроено,
		БиблиотекаКартинок.РегламентноеЗадание, Новый Картинка);
	
	Заголовок = ОбменДаннымиСервер.ПереопределяемоеИмяУзлаПланаОбмена(НастроеннаяСинхронизация.УзелИнформационнойБазы, "ЗаголовокУзлаПланаОбмена");
	
	ЕстьПравоНаПросмотрЖурналаРегистрации = Пользователи.РолиДоступны("ПросмотрЖурналаРегистрации");
	
	Если ЕстьПравоНаПросмотрЖурналаРегистрации Тогда
		
		Элементы.ДатаУспешнойЗагрузки.Видимость = Истина;
		Элементы.ДатаУспешнойВыгрузки.Видимость = Истина;
		Элементы.НадписьДатаПолучения.Видимость = Ложь;
		Элементы.НадписьДатаОтправки.Видимость = Ложь;
		
		Элементы.ДатаУспешнойЗагрузки.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойЗагрузки;
		Элементы.ДатаУспешнойВыгрузки.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойВыгрузки;
		
	Иначе
		
		Элементы.ДатаУспешнойЗагрузки.Видимость = Ложь;
		Элементы.ДатаУспешнойВыгрузки.Видимость = Ложь;
		Элементы.НадписьДатаПолучения.Видимость = Истина;
		Элементы.НадписьДатаОтправки.Видимость = Истина;
		
		Элементы.НадписьДатаПолучения.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойЗагрузки;
		Элементы.НадписьДатаОтправки.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойВыгрузки;
		
	КонецЕсли;
	
	ПустаяДата = Дата(1, 1, 1);
	
	Если НастроеннаяСинхронизация.ДатаПоследнейУспешнойВыгрузки <> НастроеннаяСинхронизация.ДатаПоследнейВыгрузки
		Или НастроеннаяСинхронизация.ДатаПоследнейВыгрузки <> ПустаяДата
		Или НастроеннаяСинхронизация.РезультатПоследнейВыгрузкиДанных <> 0 Тогда
		
		ПодсказкаВыгрузки = НСтр("ru = 'Данные отправлены: %ДатаОтправки%
										|Последняя попытка: %ДатаПопытки%'");
		ПодсказкаВыгрузки = СтрЗаменить(ПодсказкаВыгрузки, "%ДатаОтправки%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойВыгрузки);
		ПодсказкаВыгрузки = СтрЗаменить(ПодсказкаВыгрузки, "%ДатаПопытки%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейВыгрузки);
		
	Иначе
		
		ПодсказкаВыгрузки = "";
		
	КонецЕсли;
	
	Если НастроеннаяСинхронизация.ДатаПоследнейУспешнойЗагрузки <> НастроеннаяСинхронизация.ДатаПоследнейЗагрузки
		Или НастроеннаяСинхронизация.ДатаПоследнейЗагрузки <> ПустаяДата
		Или НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных <> 0 Тогда
		
		ПодсказкаЗагрузки = НСтр("ru = 'Данные получены: %ДатаПолучения%
										|Последняя попытка: %ДатаПопытки%'");
		ПодсказкаЗагрузки = СтрЗаменить(ПодсказкаЗагрузки, "%ДатаПолучения%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойЗагрузки);
		ПодсказкаЗагрузки = СтрЗаменить(ПодсказкаЗагрузки, "%ДатаПопытки%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейЗагрузки);
		
	Иначе
		
		ПодсказкаЗагрузки = "";
		
	КонецЕсли;
	
	Если НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных =2 Тогда
		НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных = ?(ОбменДаннымиСервер.ОбменДаннымиВыполненСПредупреждениями(НастроеннаяСинхронизация.УзелИнформационнойБазы), 2, 0);
	КонецЕсли;
	
	КартинкаСтатуса(Элементы.ДекорацияСтатусЗагрузки, НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных, ПодсказкаЗагрузки);
	КартинкаСтатуса(Элементы.ДекорацияСтатусВыгрузки, НастроеннаяСинхронизация.РезультатПоследнейВыгрузкиДанных, ПодсказкаВыгрузки);
	
	Элементы.ДекорацияСтатусПустой.Видимость = Истина;
	Если НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных <> 0
		Или (НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных = 0
		И НастроеннаяСинхронизация.РезультатПоследнейВыгрузкиДанных = 0) Тогда
		
		Элементы.ДекорацияСтатусПустой.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.ДекорацияУспешнаяЗагрузка.Подсказка = Элементы.ДекорацияСтатусЗагрузки.Подсказка;
	Элементы.ДекорацияУспешнаяВыгрузка.Подсказка = Элементы.ДекорацияСтатусВыгрузки.Подсказка;
	
	
	
	Если ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(НастроеннаяСинхронизация.УзелИнформационнойБазы) Тогда
		
		Элементы.ВыполнитьОбменДаннымиИнтерактивно2.Видимость = Ложь;
		
	КонецЕсли;
	
	ОписаниеПравилСинхронизацииДанных = ОбменДаннымиСервер.ОписаниеПравилСинхронизацииДанных(НастроеннаяСинхронизация.УзелИнформационнойБазы);
	Элементы.ОписаниеПравилСинхронизацииДанных.Высота = СтрЧислоСтрок(ОписаниеПравилСинхронизацииДанных);
	
	РасписаниеУзлаИнформационнойБазы = РасписаниеУзлаИнформационнойБазы(НастроеннаяСинхронизация.УзелИнформационнойБазы);
	
	Если РасписаниеУзлаИнформационнойБазы <> Неопределено Тогда
		
		РасписаниеСинхронизацииДанных = РасписаниеУзлаИнформационнойБазы;
		
	Иначе
		
		РасписаниеСинхронизацииДанных = НСтр("ru = 'Расписание синхронизации не настроено'");;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандыСозданияНовогоОбмена()
	
	ЕстьПравоНаАдминистрированиеДанных = ПравоДоступа("АдминистрированиеДанных", Метаданные);
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.СписокПлановОбменаБСП();
	
	Для Каждого Элемент Из СписокПлановОбмена Цикл
		
		ИмяПланаОбмена = Элемент.Значение;
		МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
		
		ЭтоПланОбменаXDTO = ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена);
		
		Если Метаданные.ПланыОбмена[ИмяПланаОбмена].РаспределеннаяИнформационнаяБаза Тогда
			РодительскаяГруппа = Элементы.ПодменюРИБ;
		Иначе
			РодительскаяГруппа = Элементы.ПодменюДругиеПрограммы;
		КонецЕсли;
		
		Если МенеджерПланаОбмена.ИспользоватьПомощникСозданияОбменаДанными() 
			И ОбменДаннымиПовтИсп.ДоступноИспользованиеПланаОбмена(ИмяПланаОбмена) Тогда
			
			СписокВозможныхНастроекОбмена = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "ВариантыНастроекОбмена");
			
			Если СписокВозможныхНастроекОбмена.Количество() > 0 Тогда
				
				СуммирующаяГруппа = РодительскаяГруппа;
				
				Если СписокВозможныхНастроекОбмена.Количество() > 1 Тогда 
					
					ВидГруппыКнопок = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "ВидГруппыДляВариантовНастроек");
					// Не прячем варианты обмена в подменю, если план обмена один.
					Если СписокПлановОбмена.Количество() = 1 Тогда
						ВидГруппыКнопок = ВидГруппыФормы.ГруппаКнопок;
					КонецЕсли;
					
					СуммирующаяГруппа = Элементы.Добавить(ИмяПланаОбмена, Тип("ГруппаФормы"), РодительскаяГруппа);
					
					СуммирующаяГруппа.Вид       = ВидГруппыКнопок;
					СуммирующаяГруппа.Заголовок = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "НаименованиеКонфигурацииКорреспондента");
					
				КонецЕсли;
				
				Для Каждого ПредопределеннаяНастройка Из СписокВозможныхНастроекОбмена Цикл
					
					НаименованиеКоманды = ИмяПланаОбмена + "ИдентификаторНастройки" + ПредопределеннаяНастройка;
					ЗаголовокКоманды    = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, 
					                                                                      "ЗаголовокКомандыДляСозданияНовогоОбменаДанными",
					                                                                      ПредопределеннаяНастройка);
					
					СоздатьКомандуИЭлементФормы(НаименованиеКоманды, ЗаголовокКоманды, СуммирующаяГруппа);
					
				КонецЦикла;
				
				Если МенеджерПланаОбмена.КорреспондентВМоделиСервиса() Тогда
					
					Для Каждого ПредопределеннаяНастройка Из СписокВозможныхНастроекОбмена Цикл
						
						НаименованиеКоманды = ИмяПланаОбмена + "ИдентификаторНастройки" + ПредопределеннаяНастройка + "КорреспондентВМоделиСервиса";
						ЗаголовокКоманды    = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, 
						                                                                      "ЗаголовокКомандыДляСозданияНовогоОбменаДанными",
						                                                                      ПредопределеннаяНастройка);
						
						СоздатьКомандуИЭлементФормы(НаименованиеКоманды, ЗаголовокКоманды + " " + НСтр("ru = '(в сервисе)'"), СуммирующаяГруппа);
						
					КонецЦикла;
					
				КонецЕсли;
				
			Иначе
				
				НаименованиеКоманды = ИмяПланаОбмена + "ИдентификаторНастройки";
				ЗаголовокКоманды    = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, 
				                                                                      "ЗаголовокКомандыДляСозданияНовогоОбменаДанными");
				СоздатьКомандуИЭлементФормы(НаименованиеКоманды, ЗаголовокКоманды, РодительскаяГруппа);
				
				Если МенеджерПланаОбмена.КорреспондентВМоделиСервиса() Тогда
					СоздатьКомандуИЭлементФормы(НаименованиеКоманды + "КорреспондентВМоделиСервиса", 
					                            ЗаголовокКоманды + " " + НСтр("ru = '(в сервисе)'"),
					                            РодительскаяГруппа);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущийИндексСтроки(ИмяТаблицы)
	
	// Возвращаемое значение функции.
	ИндексСтроки = Неопределено;
	
	// При обновлении монитора выполняем позиционирование курсора.
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ИндексСтроки = ЭтотОбъект[ИмяТаблицы].Индекс(ТекущиеДанные);
		
	КонецЕсли;
	
	Возврат ИндексСтроки;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПозиционированиеКурсора(ИмяТаблицы, ИндексСтроки)
	
	Если ИндексСтроки <> Неопределено Тогда
		
		// Выполняем проверки позиционирования курсора после получения новых данных.
		Если ЭтотОбъект[ИмяТаблицы].Количество() <> 0 Тогда
			
			Если ИндексСтроки > ЭтотОбъект[ИмяТаблицы].Количество() - 1 Тогда
				
				ИндексСтроки = ЭтотОбъект[ИмяТаблицы].Количество() - 1;
				
			КонецЕсли;
			
			// позиционируем курсор
			Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтотОбъект[ИмяТаблицы][ИндексСтроки].ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Если спозиционировать строку не удалось, то устанавливаем текущей первую строку.
	Если Элементы[ИмяТаблицы].ТекущаяСтрока = Неопределено
		И ЭтотОбъект[ИмяТаблицы].Количество() <> 0 Тогда
		
		Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтотОбъект[ИмяТаблицы][0].ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСостояниеОбменаСГлавнымУзлом()
	
	ТребуетсяОбновление = ОбменДаннымиВызовСервера.ТребуетсяУстановкаОбновления();
	
	Элементы.ИнформационнаяПанельТребуетсяОбновление1.Видимость = ТребуетсяОбновление;
	Элементы.ИнформационнаяПанельТребуетсяОбновление.Видимость = ТребуетсяОбновление;
	
	Элементы.ВыполнитьОбменДанными2.Видимость = Не ТребуетсяОбновление;
	
КонецПроцедуры

&НаСервере
Функция СценарийСинхронизацииПоУзлу (УзелИнформационнойБазы)
	
	НастроенныйСценарий = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	СценарииОбменовДанными.Ссылка
	|ИЗ
	|	Справочник.СценарииОбменовДанными КАК СценарииОбменовДанными
	|ГДЕ
	|	СценарииОбменовДанными.НастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СценарииОбменовДанными.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НастроенныйСценарий = Выборка.Ссылка;
		
	КонецЕсли;
	
	Возврат НастроенныйСценарий;
	
КонецФункции

&НаСервере
Функция РасписаниеУзлаИнформационнойБазы(УзелИнформационнойБазы)
	
	РасписаниеРегламентногоЗадания = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	СценарииОбменовДанными.РегламентноеЗаданиеGUID
	|ИЗ
	|	Справочник.СценарииОбменовДанными КАК СценарииОбменовДанными
	|ГДЕ
	|	СценарииОбменовДанными.ИспользоватьРегламентноеЗадание = ИСТИНА
	|	И СценарииОбменовДанными.НастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СценарииОбменовДанными.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Выборка.Следующий();
		
		РегламентноеЗаданиеОбъект = ОбменДаннымиВызовСервера.НайтиРегламентноеЗаданиеПоПараметру(Выборка.РегламентноеЗаданиеGUID);
		Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
			РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РасписаниеРегламентногоЗадания;
	
КонецФункции

&НаСервере
Процедура КартинкаСтатуса(ЭлементУправления, ВидСобытия, Подсказка)

	Если ВидСобытия = 1 Тогда
		ЭлементУправления.Картинка = БиблиотекаКартинок.СостояниеОбменаДаннымиОшибка;
		ЭлементУправления.Видимость = Истина;
	ИначеЕсли ВидСобытия = 2 Тогда
		ЭлементУправления.Картинка = БиблиотекаКартинок.Предупреждение;
		ЭлементУправления.Видимость = Истина;
	Иначе
		ЭлементУправления.Видимость = Ложь;
	КонецЕсли;
	
	ЭлементУправления.Подсказка = Подсказка;
	
КонецПроцедуры

&НаСервере
Функция ПодробнаяИнформацияНаСервере(УзелОбмена)
	
	МенеджерПланаОбмена = ПланыОбмена[УзелОбмена.Метаданные().Имя];
	
	ВариантНастройкиОбмена = ОбменДаннымиСервер.СохраненныйВариантНастройкиУзлаПланаОбмена(УзелОбмена);
	СсылкаНаПодробноеОписание = МенеджерПланаОбмена.ПодробнаяИнформацияПоОбмену(ВариантНастройкиОбмена);
	
	Возврат СсылкаНаПодробноеОписание;
	
КонецФункции

&НаКлиенте
Процедура ПродолжитьВыполнениеСинхронизации(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ИнтерактивнаяОтправка Тогда
		
		ОбменДаннымиКлиент.ОткрытьПомощникСопоставленияОбъектовОбработкаКоманды(ДополнительныеПараметры.УзелОбмена, ЭтотОбъект);
		
	Иначе
		
		ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(ДополнительныеПараметры.УзелОбмена,
			ЭтотОбъект,, ДополнительныеПараметры.АвтоматическаяСинхронизация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСовместимостьПравилКонвертации(Знач ИмяПланаОбмена, ОбработкаПродолжения)
	
	ОписаниеОшибки = Неопределено;
	Если ПравилаКонвертацииСовместимыСТекущейВерсией(ИмяПланаОбмена, ОписаниеОшибки) Тогда
		
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения);
		
	Иначе
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ПерейтиКЗагрузкеПравил", НСтр("ru = 'Загрузить правила'"));
		Если ОписаниеОшибки.ВидОшибки <> "НекорректнаяКонфигурация" Тогда
			Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
		КонецЕсли;
		Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
		ДополнительныеПараметры.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
		Оповещение = Новый ОписаниеОповещения("ПослеПроверкиПравилКонвертацииНаСовместимость", ЭтотОбъект, ДополнительныеПараметры);
		
		ПараметрыФормы = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
		ПараметрыФормы.Картинка = ОписаниеОшибки.Картинка;
		ПараметрыФормы.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
		Если ОписаниеОшибки.ВидОшибки = "НекорректнаяКонфигурация" Тогда
			ПараметрыФормы.Заголовок = НСтр("ru = 'Синхронизация данных не может быть выполнена'");
		Иначе
			ПараметрыФормы.Заголовок = НСтр("ru = 'Синхронизация данных может быть выполнена некорректно'");
		КонецЕсли;
		
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, ОписаниеОшибки.ТекстОшибки, Кнопки, ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиПравилКонвертацииНаСовместимость(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если Результат.Значение = "Продолжить" Тогда
			
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработкаПродолжения);
			
		ИначеЕсли Результат.Значение = "ПерейтиКЗагрузкеПравил" Тогда
			
			ОбменДаннымиКлиент.ЗагрузитьПравилаСинхронизацииДанных(ДополнительныеПараметры.ИмяПланаОбмена);
			
		КонецЕсли; // При "Отмена" ничего не делаем.
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПравилаКонвертацииСовместимыСТекущейВерсией(ИмяПланаОбмена, ОписаниеОшибки)
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(ИмяПланаОбмена);
	ИнформацияОПравилах = Неопределено;
	
	Если ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "ПредупреждатьОНесоответствииВерсийПравилОбмена")
		И ПравилаКонвертацииЗагруженыИзФайла(ИмяПланаОбмена, ИнформацияОПравилах) Тогда
		
	ИмяКонфигурацииИзПравил = ВРег(ИнформацияОПравилах.ИмяКонфигурации);
	ИмяКонфигурацииИнформационнойБазы = СтрЗаменить(ВРег(Метаданные.Имя), "БАЗОВАЯ", "");
	Если ИмяКонфигурацииИзПравил <> ИмяКонфигурацииИнформационнойБазы Тогда
			
			ОписаниеОшибки = Новый Структура;
			ОписаниеОшибки.Вставить("ТекстОшибки", НСтр("ru = 'Синхронизация данных не может быть выполнена, так как используются правила, предназначенные для программы ""%1"". Следует использовать правила из конфигурации или загрузить корректный комплект правил из файла.'"));
			ОписаниеОшибки.ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеОшибки.ТекстОшибки, ИнформацияОПравилах.СинонимКонфигурацииВПравилах);
			ОписаниеОшибки.Вставить("ВидОшибки", "НекорректнаяКонфигурация");
			ОписаниеОшибки.Вставить("Картинка", БиблиотекаКартинок.Ошибка32);
			Возврат Ложь;
			
		КонецЕсли;
		
		ВерсияВПравилахБезСборки    = ОбщегоНазначенияКлиентСервер.ВерсияКонфигурацииБезНомераСборки(ИнформацияОПравилах.ВерсияКонфигурации);
		ВерсияКонфигурацииБезСборки = ОбщегоНазначенияКлиентСервер.ВерсияКонфигурацииБезНомераСборки(Метаданные.Версия);
		РезультатСравнения          = ОбщегоНазначенияКлиентСервер.СравнитьВерсииБезНомераСборки(ВерсияВПравилахБезСборки, ВерсияКонфигурацииБезСборки);
		
		Если РезультатСравнения <> 0 Тогда
			
			Если РезультатСравнения < 0 Тогда
				
				ТекстОшибки = НСтр("ru = 'Синхронизация данных может быть выполнена некорректно, так как используются правила, предназначенные для предыдущей версии программы ""%1"" (%2). Рекомендуется использовать правила из конфигурации или загрузить комплект правил, предназначенный для текущей версии программы (%3).'");
				ВидОшибки = "УстаревшаяВерсияКонфигурации";
				
			Иначе
				
				ТекстОшибки = НСтр("ru = 'Синхронизация данных может быть выполнена некорректно, так как используются правила, предназначенные для более новой версии программы ""%1"" (%2). Рекомендуется обновить версию программы или использовать комплект правил, предназначенный для текущей версии программы (%3).'");
				ВидОшибки = "УстаревшиеПравила";
				
			КонецЕсли;
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Метаданные.Синоним, ВерсияВПравилахБезСборки, ВерсияКонфигурацииБезСборки);
			
			ОписаниеОшибки = Новый Структура;
			ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
			ОписаниеОшибки.Вставить("ВидОшибки", ВидОшибки);
			ОписаниеОшибки.Вставить("Картинка", БиблиотекаКартинок.Предупреждение32);
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПравилаКонвертацииЗагруженыИзФайла(ИмяПланаОбмена, ИнформацияОПравилах)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПравилаДляОбменаДанными.ПравилаЗачитанные,
	|	ПравилаДляОбменаДанными.ВидПравил
	|ИЗ
	|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
	|ГДЕ
	|	ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена
	|	И ПравилаДляОбменаДанными.ИсточникПравил = ЗНАЧЕНИЕ(Перечисление.ИсточникиПравилДляОбменаДанными.Файл)
	|	И ПравилаДляОбменаДанными.ПравилаЗагружены = ИСТИНА
	|	И ПравилаДляОбменаДанными.ВидПравил = ЗНАЧЕНИЕ(Перечисление.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов)";
	
	Запрос.УстановитьПараметр("ИмяПланаОбмена", ИмяПланаОбмена);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		СтруктураПравил = Выборка.ПравилаЗачитанные.Получить().Конвертация;
		
		ИнформацияОПравилах = Новый Структура;
		ИнформацияОПравилах.Вставить("ИмяКонфигурации", СтруктураПравил.Источник);
		ИнформацияОПравилах.Вставить("ВерсияКонфигурации", СтруктураПравил.ВерсияКонфигурацииИсточника);
		ИнформацияОПравилах.Вставить("СинонимКонфигурацииВПравилах", СтруктураПравил.СинонимКонфигурацииИсточника);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура СоздатьКомандуИЭлементФормы(НаименованиеКоманды, Заголовок, Подменю)
	
	Команды.Добавить(НаименованиеКоманды);
	Команды[НаименованиеКоманды].Заголовок = Заголовок + "...";
	Команды[НаименованиеКоманды].Действие  = "ОткрытьПомощникНастройкиОбменаДанными";
	
	Элементы.Добавить(НаименованиеКоманды, Тип("КнопкаФормы"), Подменю);
	Элементы[НаименованиеКоманды].ИмяКоманды = НаименованиеКоманды;
	
КонецПроцедуры

#КонецОбласти
