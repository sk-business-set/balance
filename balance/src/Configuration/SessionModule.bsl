#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
Попытка	
	ПараметрыСеанса.ПодразделениеПользователя=УправлениеДоступомОформлением.ОсновноеПодразделениеПользователя(ПараметрыСеанса.ТекущийПользователь);
	фмПодразделения=Новый ФиксированныйМассив(УправлениеДоступомОформлением.РазрешенныеПодразделенияПользователя(ПараметрыСеанса.ТекущийПользователь));
	ПараметрыСеанса.ПодразделенияПользователя=фмПодразделения;
	фмПодразделения=Новый ФиксированныйМассив(УправлениеДоступомОформлением.РазрешенныеСтатьиДвиженияПользователя(ПараметрыСеанса.ТекущийПользователь));
	ПараметрыСеанса.СтатьиДвиженияПользователя=фмПодразделения;
	фмБДвижения=Новый ФиксированныйМассив(УправлениеДоступомОформлением.РазрешенныеБДвиженияПользователя(ПараметрыСеанса.ТекущийПользователь));
	ПараметрыСеанса.КнопкиПользователя=фмБДвижения;
Исключение
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

#КонецЕсли