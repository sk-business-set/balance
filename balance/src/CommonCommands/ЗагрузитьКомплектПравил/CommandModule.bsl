#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбменДаннымиКлиент.ЗагрузитьПравилаСинхронизацииДанных(ИмяПланаОбмена(ПараметрКоманды));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИмяПланаОбмена(Знач УзелИнформационнойБазы)
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы);
	
КонецФункции

#КонецОбласти