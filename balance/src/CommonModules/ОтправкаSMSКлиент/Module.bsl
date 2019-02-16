////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отправка SMS"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму для отправки нового SMS.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +<КодСтраны><КодDEF><номер>(строкой);
//  Текст             - Строка - текст сообщения, длиной не более 1000 символов;
//  ДополнительныеПараметры- Структура - дополнительные параметры отправки SMS.
//    * ИмяОтправителя - Строка - имя отправителя, которое будет отображаться вместо номера у получателей.
//    * ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой.
Процедура ОтправитьSMS(НомераПолучателей, Текст, ДополнительныеПараметры) Экспорт
	
	СтандартнаяОбработка = Истина;
	ОтправкаSMSКлиентПереопределяемый.ПриОтправкеSMS(НомераПолучателей, Текст, ДополнительныеПараметры, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		ПараметрыОтправки = Новый Структура("НомераПолучателей, Текст, ДополнительныеПараметры, ПараметрыРаботыКлиента");
		ПараметрыОтправки.НомераПолучателей = НомераПолучателей;
		ПараметрыОтправки.Текст = Текст;
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
			ПараметрыОтправки.ДополнительныеПараметры = ДополнительныеПараметры;
		Иначе
			ПараметрыОтправки.ДополнительныеПараметры = Новый Структура;
		КонецЕсли;
		Если НЕ ПараметрыОтправки.ДополнительныеПараметры.Свойство("ПеревестиВТранслит") Тогда
			ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПеревестиВТранслит", Ложь);
		КонецЕсли;
		Если НЕ ПараметрыОтправки.ДополнительныеПараметры.Свойство("ИсточникКонтактнойИнформации") Тогда
			ПараметрыОтправки.ДополнительныеПараметры.Вставить("ИсточникКонтактнойИнформации", "");
		КонецЕсли;

		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьНовоеSMSПроверкаНастроекВыполнена", ЭтотОбъект, ПараметрыОтправки);
		ПроверитьНаличиеНастроекДляОтправкиSMS(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Если у пользователя нет настроек для отправки SMS, то в зависимости от прав либо показывает
// форму настройки SMS, либо выводит сообщение о невозможности отправки.
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещение - процедура, в которую необходимо передать выполнение кода после проверки.
//
Процедура ПроверитьНаличиеНастроекДляОтправкиSMS(ОбработчикРезультата)
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	Если ПараметрыРаботыКлиента.ДоступнаОтправкаSMS Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	Иначе
		Если ПараметрыРаботыКлиента.ЭтоПолноправныйПользователь Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНастройкиSMS", ЭтотОбъект, ОбработчикРезультата);
			ОткрытьФорму("ОбщаяФорма.НастройкаОтправкиSMS",,,,,, ОписаниеОповещения);
		Иначе
			ТекстСообщения = НСтр("ru = 'Для отправки SMS требуется произвести настройку параметров подключения
				|Обратитесь к администратору.'");
			ПоказатьПредупреждение(, ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеНастройкиSMS(Результат, ОбработчикРезультата) Экспорт
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	Если ПараметрыРаботыКлиента.ДоступнаОтправкаSMS Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	КонецЕсли;
КонецПроцедуры

// Продолжение процедуры ОтправитьSMS.
Процедура СоздатьНовоеSMSПроверкаНастроекВыполнена(ОтправкаSMSНастроена, ПараметрыОтправки) Экспорт
	Если ОтправкаSMSНастроена Тогда
		ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия")
			И ПараметрыРаботыКлиента.ИспользоватьПрочиеВзаимодействия Тогда
				Адресаты = Новый Массив;
				Для каждого ЭлементМассива Из ПараметрыОтправки.НомераПолучателей Цикл
					Телефон = Новый Структура("Телефон, Представление, ИсточникКонтактнойИнформации", ЭлементМассива, ЭлементМассива, ПараметрыОтправки.ДополнительныеПараметры.ИсточникКонтактнойИнформации);
					Адресаты.Добавить(Телефон);
				КонецЦикла;
				МодульВзаимодействияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВзаимодействияКлиент");
				МодульВзаимодействияКлиент.ОткрытьФормуОтправкиSMS(Адресаты, ПараметрыОтправки.Текст,, ПараметрыОтправки.ДополнительныеПараметры.ПеревестиВТранслит);
		Иначе
			ОткрытьФорму("ОбщаяФорма.ОтправкаSMS", ПараметрыОтправки);
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти