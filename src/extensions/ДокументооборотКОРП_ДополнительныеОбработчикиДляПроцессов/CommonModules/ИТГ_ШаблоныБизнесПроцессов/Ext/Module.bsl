﻿#Область СлужебныйПрограммныйИнтерфейс

//	Получает полную роль делопроизводителя подразделения, осуществляющего делопроизводство по документу.
//
// Параметры:
//   БизнесПроцессОбъект - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//                         вычисляется автоподстановка
//   ИмяПредмета - СправочникСсылка.ИменаПредметов - имя предмета в процессе
//
//	Возвращаемое значение:
//		СправочникСсылка.ПолныеРоли.
//
Функция ДелопроизводительПодразделенияДокумента(БизнесПроцессОбъект, ИмяПредмета) Экспорт
	
	СтрокаПредмета = БизнесПроцессОбъект.Предметы.Найти(ИмяПредмета, "ИмяПредмета");
	
	Если СтрокаПредмета <> Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоподстановка не может быть выполнена, так как не указан предмет ""%1"" процесса.'"),
				Строка(ИмяПредмета));
		КонецЕсли;
			
		ДокументСсылка = СтрокаПредмета.Предмет;
		
		Если Не ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(ДокументСсылка) Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоподстановка не может быть выполнена, так как предмет ""%1"" процесса не является документом.'"),
				Строка(ИмяПредмета));
		КонецЕсли;
			
		ПодразделениеДокумента = ДокументСсылка.Подразделение;
			
		Если ПодразделениеДокумента.Пустая() Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоподстановка не может быть выполнена, так как в предмете ""%1"" процесса не заполнено подразделение.'"),
				Строка(ИмяПредмета));
		КонецЕсли;
		
		// TODO: в дальнейшем - Справочники.РолиИсполнителей.ДелопроизводительПодразделения;
		РольДелопроизводителя = Справочники.РолиИсполнителей.НайтиСоздатьРоль_ДелопроизводительПодразделения();
		
		ПолнаяРольДелопроизводителя = Справочники.ПолныеРоли.НайтиСоздатьПолнуюРоль(
			РольДелопроизводителя,
			ПодразделениеДокумента);
		
		Возврат ПолнаяРольДелопроизводителя;
		
	Иначе
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найден предмет ""%1"" процесса.'"),
			Строка(ИмяПредмета));
			
	КонецЕсли;

КонецФункции

//	Получает полную роль руководителя подразделения, осуществляющего делопроизводство по документу.
//
// Параметры:
//   БизнесПроцессОбъект - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//                         вычисляется автоподстановка
//   ИмяПредмета - СправочникСсылка.ИменаПредметов - имя предмета в процессе
//
//	Возвращаемое значение:
//		СправочникСсылка.ПолныеРоли или СправочникСсылка.Пользователи
//
Функция РуководительПодразделенияДокумента(БизнесПроцессОбъект, ИмяПредмета) Экспорт
	
	СтрокаПредмета = БизнесПроцессОбъект.Предметы.Найти(ИмяПредмета, "ИмяПредмета");
	
	Если СтрокаПредмета <> Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоподстановка не может быть выполнена, так как не указан предмет ""%1"" процесса.'"),
				Строка(ИмяПредмета));
		КонецЕсли;
			
		ДокументСсылка = СтрокаПредмета.Предмет;
		
		Если Не ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(ДокументСсылка) Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоподстановка не может быть выполнена, так как предмет ""%1"" процесса не является документом.'"),
				Строка(ИмяПредмета));
		КонецЕсли;
			
		ПодразделениеДокумента = ДокументСсылка.Подразделение;
			
		Если ПодразделениеДокумента.Пустая() Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоподстановка не может быть выполнена, так как в предмете ""%1"" процесса не заполнено подразделение.'"),
				Строка(ИмяПредмета));
		КонецЕсли;
		
		// TODO: в дальнейшем - Справочники.РолиИсполнителей.РуководительПодразделения;
		РольРуководителяПодразделения = Справочники.РолиИсполнителей.НайтиСоздатьРоль_РуководительПодразделения();
		
		ПолнаяРольРуководителяПодразделения = Справочники.ПолныеРоли.НайтиСоздатьПолнуюРоль(
			РольРуководителяПодразделения,
			ПодразделениеДокумента);
			
		// проверим, есть ли у роли действительные исполнители	
		Если РегистрыСведений.ИсполнителиЗадач.ИсполнителиРоли(ПолнаяРольРуководителяПодразделения, Истина).Количество() > 0 Тогда
			Возврат ПолнаяРольРуководителяПодразделения;
		Иначе
			// если действительных исполнителей у роли нет, вернём руководителя подразделения из структуры организации
			Возврат ПодразделениеДокумента.Руководитель;
		КонецЕсли;
		
	Иначе
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найден предмет ""%1"" процесса.'"),
			Строка(ИмяПредмета));
			
	КонецЕсли;

КонецФункции

#КонецОбласти
