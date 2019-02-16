
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Структура подчиненности".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует массив реквизитов документа. 
// 
// Параметры: 
// ИмяДокумента - Строка - имя документа.
// 
// Возвращаемое значение: 
// Массив - массив наименований реквизитов документа. 
// 
Функция МассивРеквизитовОбъектаДляФормированияПредставления(ИмяДокумента) Экспорт
	
	МассивДопРеквизитов = Новый Массив;
	
	
	
	Возврат МассивДопРеквизитов
	
КонецФункции

// Получает представление документа для печати.
//
// Параметры:
//  Выборка  - КоллекцияДанных - структура или выборка из результатов запроса
//                 в которой содержатся дополнительные реквизиты, на основании
//                 которых можно сформировать переопределенное представление 
//                 документа для вывода в отчет "Структура подчиненности".
//
// Возвращаемое значение:
//   Строка,Неопределено   - переопределенное представление документа, или Неопределено,
//                           если для данного типа документов такое не задано.
//
Функция ПредставлениеОбъектаДляВыводаВОтчет(Выборка) Экспорт
	
	
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает имя реквизита документа, в котором содержится информация о Сумме и Валюте документа для вывода в
// структуру подчиненности.
// По умолчанию используются реквизиты Валюта и СуммаДокумента. Если для конкретного документа или конфигурации в целом
// используются другие
// реквизиты, то переопределить значения по умолчанию можно в данной функции.
//
// Параметры:
//  ИмяДокумента  - Строка - имя документа, для которого надо получить имя реквизита.
//  Реквизит      - Строка - Строка, может принимать значения "Валюта" и "СуммаДокумента".
//
// Возвращаемое значение:
//   Строка   - Имя реквизита документа, в котором содержится информация о Валюте или Сумме.
//
Функция ИмяРеквизитаДокумента(ИмяДокумента, Реквизит) Экспорт
	
	
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
