
Функция ПолучитьВалютуПоКоду(текКод) Экспорт
	Результат=Справочники.Валюты.ПустаяСсылка();
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	Валюты.Ссылка
	             |ИЗ
	             |	Справочник.Валюты КАК Валюты
	             |ГДЕ
	             |	Валюты.Код = &Код";
	Запрос.УстановитьПараметр("Код",текКод);
	Валюта=Запрос.Выполнить().Выбрать();
	Пока Валюта.Следующий() Цикл
		Результат=Валюта.Ссылка;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ПолучитьВалютуПоСимвКоду(текКод) Экспорт
	Результат=Справочники.Валюты.ПустаяСсылка();
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	Валюты.Ссылка
	             |ИЗ
	             |	Справочник.Валюты КАК Валюты
	             |ГДЕ
	             |	Валюты.Наименование = &Код";
	Запрос.УстановитьПараметр("Код",текКод);
	Валюта=Запрос.Выполнить().Выбрать();
	Пока Валюта.Следующий() Цикл
		Результат=Валюта.Ссылка;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ПолучитьКурс(текДата=Неопределено,текВалюта) Экспорт
	Если текДата=Неопределено тогда
		текДата=ТекущаяДата();
	КонецЕсли;
	Результат=Новый Структура("Курс,Кратность",1.0000,1);
	Если НЕ (текВалюта.Код="643" или текВалюта.Пустая()) тогда
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		             |	КурсыВалютСрезПоследних.Курс,
		             |	КурсыВалютСрезПоследних.Кратность
		             |ИЗ
		             |	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыВалютСрезПоследних";
		Запрос.УстановитьПараметр("Дата",текДата);
		Запрос.УстановитьПараметр("Валюта",текВалюта);
		Валюта=Запрос.Выполнить().Выбрать();
		Пока Валюта.Следующий() Цикл
			Результат.Курс=Валюта.Курс;
			Результат.Кратность=Валюта.Кратность;
		КонецЦикла;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ПересчитатьВВалюту(текСумма,текВалюта,НовВалюта) Экспорт
	текКурс=РаботаСВалютой.ПолучитьКурс(,текВалюта);
	НовКурс=РаботаСВалютой.ПолучитьКурс(,НовВалюта);
	Возврат (текСумма*текКурс.Курс*НовКурс.Кратность/(текКурс.Кратность*НовКурс.Курс));
КонецФункции

Функция ПолучитьКурсПоКоду(текДата=Неопределено,текВалюта) Экспорт
	Если текДата=Неопределено тогда
		текДата=ТекущаяДата();
	КонецЕсли;
	Результат=Новый Структура("Курс,Кратность",1.0000,1);
	Если НЕ текВалюта.Код="643" тогда
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		             |	КурсыВалютСрезПоследних.Курс,
		             |	КурсыВалютСрезПоследних.Кратность
		             |ИЗ
		             |	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, ) КАК КурсыВалютСрезПоследних
		             |ГДЕ
		             |	КурсыВалютСрезПоследних.Валюта.Код = &Код";
		Запрос.УстановитьПараметр("Дата",текДата);
		Запрос.УстановитьПараметр("Код",текВалюта);
		Валюта=Запрос.Выполнить().Выбрать();
		Пока Валюта.Следующий() Цикл
			Результат.Курс=Валюта.Курс;
			Результат.Кратность=Валюта.Кратность;
		КонецЦикла;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция УстановленКурс(текДата,текВалюта) Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	КурсыВалют.Курс,
	             |	КурсыВалют.Кратность
	             |ИЗ
	             |	РегистрСведений.КурсыВалют КАК КурсыВалют
	             |ГДЕ
	             |	КурсыВалют.Валюта = &Валюта
	             |	И НАЧАЛОПЕРИОДА(КурсыВалют.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Период, ДЕНЬ)";
	Запрос.УстановитьПараметр("Период",текДата);
	Запрос.УстановитьПараметр("Валюта",текВалюта);
	Валюта=Запрос.Выполнить().Выгрузить();
	Возврат (Валюта.Количество()>0);
КонецФункции

Процедура УстановитьКурс(текДата,текВалюта,текКурс,текКратность) Экспорт
	НаборКурсов=РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
	НаборКурсов.Отбор.Валюта.Установить(текВалюта);
	НаборКурсов.Отбор.Период.Установить(НачалоДня(ТекДата));
	НаборКурсов.Прочитать();
	Если НаборКурсов.Количество() = 0 Тогда
	    НовыйКурс = НаборКурсов.Добавить();
	    НовыйКурс.Валюта = текВалюта;
	    НовыйКурс.Период = ТекДата;
	ИначеЕсли НаборКурсов.Количество() = 1 Тогда
	    НовыйКурс = НаборКурсов[0];
	Иначе
	    Сообщение = Новый СообщениеПользователю();
    	Сообщение.Текст = НСтр("ru = 'Курс валюты задается один раз в день.';"
	     + " en = 'Rate is set once a day.'");
		 Сообщение.Сообщить();
	    Возврат;
	КонецЕсли;
	НовыйКурс.Курс = текКурс;
	НовыйКурс.Кратность = текКратность;
	НаборКурсов.Записать();
КонецПроцедуры

Процедура ПроверитьОсновнуюВалюту() Экспорт
	Валюты=Константы.МультивалютныйУчет.Получить();
	Если Валюты тогда
		текВалюта=Константы.ОсновнаяВалюта.Получить();
		Если текВалюта.Пустая() тогда
			Константы.ОсновнаяВалюта.Установить(РаботаСВалютойСлужебный.ПолучитьРубль());
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

