package com.marathonsystems.mehaleye

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import com.ryanheise.audioservice.AudioServiceActivity
import org.joda.time.LocalDate
import org.joda.time.chrono.EthiopicChronology
import org.joda.time.chrono.GregorianChronology

open class MonthlyHolidaysWidgetProvider : AppWidgetProvider() {

    private val TAG = "MONTHLY_HOLIDAY_TAG"


    lateinit var shared: SharedPreferences

    private val CHANGE_LANG = "CHANGE_LANG"
    private val CURRENT_LANG = "CURRENT_LANG"
    private val AM = "AM"
    private val EN = "EN"

    private val MONTHLY_HOLIDAY_WIDGET_VALUES = "MONTHLY_HOLIDAY_WIDGET_VALUES"
    private val OPEN_APP_AM = "መተግበሪያውን ክፈት"
    private val OPEN_APP_EN = "OPEN APP"
    private val SELECTED_LAN_EN = "English"
    private val SELECTED_LAN_AM = "አማርኛ"
    private val TITLE_EN = "today's monthly holidays"
    private val TITLE_AM = "የዛሬ ወርሃዊ በዓላት"

    private val holidaysList = listOf<MonthlyHoliday>(
        MonthlyHoliday(
            day = 1,
            holidayNameEn = "Ledata Mariam, Archangel Raguel, Bartholomew the Apostle, Prophet Elijah",
            holidayNameAm = "ልደታ ማርያም ፣ ራጉኤል ፣ ሐዋርያው በርተሎሜዎስ ፣ነብዩ ኤልያስ"
        ),
        MonthlyHoliday(
            day = 2,
            holidayNameEn = "Thaddeus the Apostle,Abba Guba",
            holidayNameAm = "ሐዋርያው ታድዮስ ፣ አባ ጉባ"
        ),
        MonthlyHoliday(
            day = 3,
            holidayNameEn = "Beata,Abune Zena Markos, Archangel Phanuel, Saint Neakuto Leab",
            holidayNameAm = "በአታለማርያም ፣ አቡነ ዜና ማርቆስ ፣ ቅዱስ ፋኑኤል"
        ),
        MonthlyHoliday(
            day = 4,
            holidayNameEn = "John the son of the Thunder (Yohannis Welde Negedguad), Andrew the Apostle",
            holidayNameAm = "ዮሐንስ ወልደ ነጎድጓድ ፣ ሐዋርያው እንድርያስ"
        ),
        MonthlyHoliday(
            day = 5,
            holidayNameEn = "Petros we Paulos (Peter and Paul) and Abuna Gebre Menfes Kidus, Abune Arone",
            holidayNameAm = "ጴጥሮስወ ጳውሎስ ፣ ገብረ መንፈስ ቅዱስ ፣ አቡነ አሮን"
        ),
        MonthlyHoliday(
            day = 6,
            holidayNameEn = "Iyyasus, Dabra Quesqam Mariam, Saint Arsema",
            holidayNameAm = "ኢየሱስ ፣ ቁስቋም ማርያም ፣ አርሴማ"
        ),
        MonthlyHoliday(
            day = 7,
            holidayNameEn = "Holy Trinity",
            holidayNameAm = "አጋዕዝተ አለም ስላሴ"
        ),
        MonthlyHoliday(
            day = 8,
            holidayNameEn = "Cherubim,Saint Matthias the Apostle, Abune Kiros, Abba Banuda",
            holidayNameAm = "ኪሩቤል አርባእቱ እንስሳ ፣ ሐዋርያው ማትያስ ፣ አቡነ ኪሮስ"
        ),
        MonthlyHoliday(
            day = 9,
            holidayNameEn = "Saint Thomas the Apostle,Abune Isitinifase Kirisitosi",
            holidayNameAm = "ሰልስቱ ምዕት፣ ሐዋርያው ቶማስ ፣ አቡነ እስትንፋሰ ክርስቶስ"
        ),
        MonthlyHoliday(
            day = 10,
            holidayNameEn = "Holy Cross (Masqal), Ts’edeniya Mariyami,Simon the Zealot",
            holidayNameAm = "መስቀለ ክርስቶስ ፣ ስምኦን ቀኖናዊ ሐዋርያ ፣ ፀደንያ ማርያም"
        ),


        MonthlyHoliday(
            day = 11,
            holidayNameEn = "Saint Hanna, the mother of our holy Mother, Saint Joachim, the father of our holy Mother, Saint Yared,Abune Hara",
            holidayNameAm = "ሐና እና ኢያቄም ፣ ቅዱስ ያሬድ ፣ አቡነ ሐራ"
        ),
        MonthlyHoliday(
            day = 12,
            holidayNameEn = "Archangel Michael,Matthew the Apostle, Abba Samuel from Waldeba",
            holidayNameAm = "ቅዱስ ሚካኤል፣ አባ ሳሙኤል ፣ ሐዋርያ ማቴዎስ"
        ),
        MonthlyHoliday(
            day = 13,
            holidayNameEn = "Egziabher Abe (God the Father),Archangel Raphael,Saint Abba Zar’a-Buruk",
            holidayNameAm = "እግዚአብሔር አብ ፣ ቅዱስ ሩፋኤል ፣ አቡነ ዘርአ ብሩክ"
        ),
        MonthlyHoliday(
            day = 14,
            holidayNameEn = "Abuna Aragwi, Gabra Krestos the hermit",
            holidayNameAm = "አቡነ አረጋዊ ፣ገብረ ክርስቶስ,ገብረ መርአዊ"
        ),
        MonthlyHoliday(
            day = 15,
            holidayNameEn = "St. Cyriacus and St. Julietta",
            holidayNameAm = "ቂርቆስና እየሉጣ"
        ),
        MonthlyHoliday(
            day = 16,
            holidayNameEn = "Kidane Meheret - Our Lady, Covenant of Mercy",
            holidayNameAm = "ኪዳነ ምህረት"
        ),
        MonthlyHoliday(
            day = 17,
            holidayNameEn = "Saint Stefanos (Stephen the Martyr), James the apostle,Abba Gerima",
            holidayNameAm = "ቅዱስ እስጢፋኖስ ፣ ሐዋርያውያዕቆብ ወልደ ዘብዲዮስ ፣ አባ ገሪማ"
        ),
        MonthlyHoliday(
            day = 18,
            holidayNameEn = "Philip the Apostle,Abune Ewostatewos",
            holidayNameAm = "ሐዋርያው ፊሊጶስ ፣ ኢዩስጣቲዮስ"
        ),
        MonthlyHoliday(
            day = 19,
            holidayNameEn = "Gabriel the Archangel",
            holidayNameAm = "ቅዱስ ገብርኤል"
        ),
        MonthlyHoliday(
            day = 20,
            holidayNameEn = "Hnstata Betkerestyan",
            holidayNameAm = "ሕንፀተ ቤተ ክርስቲያን"
        ),


        MonthlyHoliday(
            day = 21,
            holidayNameEn = "Egze’et-na Maryam: Our Holy Mother Maryam, Mother of God",
            holidayNameAm = "ቅድስት ድንግል ማርያም"
        ),
        MonthlyHoliday(
            day = 22,
            holidayNameEn = "Archangel Uriel, Saint Daqsyos, Commemoration of the Annunciation, Saint Lukas",
            holidayNameAm = "ቅዱስ ኡራኤል ፣ ደቅስዮስ ፣ ሉቃስ ፣ ብስራተ ገብርኤል"
        ),
        MonthlyHoliday(
            day = 23,
            holidayNameEn = "Saint Georgis - George of Lydda",
            holidayNameAm = "ቅዱስ ጊዮርጊስ"
        ),
        MonthlyHoliday(
            day = 24,
            holidayNameEn = "Abuna Takla Haymanot, Saint Kirstos Semera, 24 Heavenly Priests",
            holidayNameAm = "አቡነ ተክለ ሐይማኖት ፣ ቅድስት ክርስረቶስ ሰምራ ፣ 24ቱ ካህናተ ሰማይ"
        ),
        MonthlyHoliday(
            day = 25,
            holidayNameEn = "Saint Marqorewos (Merkorios), Abune Habibe",
            holidayNameAm = "ቅዱስ መርቆሬዎስ ፣አቡነ ሀቢብ (አባ ቡላ)"
        ),
        MonthlyHoliday(
            day = 26,
            holidayNameEn = "Saint Joseph, Abba Salama- Frumentius, the En lightener of Ethiopia,Thomas the apostle, Abune Habte Mariam, Aba Eyesus Moe`a",
            holidayNameAm = "አረጋዊው ዮሴፍ ፣ አባ ሰላማ ከሳቴ ብርሀን ፣ ቶማስ ዘህንደኬ ፣ አቡነ ሀብተ ማርያም ፣ አባ ኢየሱስ ሞአ"
        ),
        MonthlyHoliday(
            day = 27,
            holidayNameEn = "Medhane Alem -The Saviour of the world, Abune Mebea Zion",
            holidayNameAm = "መድሐኔአለም ፣ አቡነ መባዓ ፅዮን"
        ),
        MonthlyHoliday(
            day = 28,
            holidayNameEn = "Emmanuel",
            holidayNameAm = "አማኑኤል"
        ),
        MonthlyHoliday(
            day = 29,
            holidayNameEn = "Ba`ale Wold (Feast of God The Son), Saint Lalibela",
            holidayNameAm = "በዓለወልድ፣ ቅዱስ ላሊበላ"
        ),
        MonthlyHoliday(
            day = 30,
            holidayNameEn = "John the baptist, Saint Markos -St. Mark the Evangelist",
            holidayNameAm = "ዮሐንስ መጥምቅ ፣ ቅዱስ ማርቆስ"
        )
    )


    override fun onUpdate(
        context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray
    ) {

        appWidgetIds.forEach { widgetId ->
            val views =
                RemoteViews(context.packageName, R.layout.monthly_holidays_widget_layout).apply {
                    // Open App on Widget Click

                    val intent = Intent(context, AudioServiceActivity::class.java)
                    val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
                    setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                    ///SET HOLIDAYS TEXTS
                    setTodayHoliday(this, context)
                    //SET VIEWS TEXT
                    setViewTexts(this, context)

                    setOnClickPendingIntent(
                        R.id.btn_change_lang,
                        getPendingSelfIntent(context, CHANGE_LANG)
                    )

                }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)

        val appWidgetManager = AppWidgetManager.getInstance(context)
        val remoteViews: RemoteViews =
            RemoteViews(context!!.packageName, R.layout.monthly_holidays_widget_layout)
        val watchWidget: ComponentName =
            ComponentName(context, MonthlyHolidaysWidgetProvider::class.java)


        if (intent != null) {
            if (CHANGE_LANG == intent.action) {
                Log.d(TAG, "onReceive: " + getLang(context))
                if (getLang(context) == AM) {
                    setLang(context, EN)
                } else {
                    setLang(context, AM)
                }
                Log.d(TAG, "onReceive: " + getLang(context))
                ///SET HOLIDAY TEXT TEXTS
                setTodayHoliday(remoteViews, context)
                //SET VIEWS TEXT
                setViewTexts(remoteViews, context)

                appWidgetManager.updateAppWidget(watchWidget, remoteViews)
            }
        }
    }


    private fun setTodayHoliday(remoteViews: RemoteViews, context: Context) {

        val index = getTodayIndex()-1

        ///SET HOLIDAY NAME AND DATE
        if (getLang(context) == AM) {
            remoteViews.setTextViewText(R.id.txt_holiday_name, holidaysList[index].holidayNameAm)
            remoteViews.setTextViewText(R.id.txt_date_today, getDateAm())
        } else {
            remoteViews.setTextViewText(R.id.txt_holiday_name, holidaysList[index].holidayNameEn)
             remoteViews.setTextViewText(R.id.txt_date_today,  getDateEn())
        }
    }

    private fun getDateEn(): String {
        val grC = LocalDate(GregorianChronology.getInstance())
        return  getMonthNameEn(grC.monthOfYear)+" "+grC.dayOfMonth+", "+grC.year
    }

    private fun getDateAm(): String {
        val etC = LocalDate(EthiopicChronology.getInstance())
        return  getMonthNameAm(etC.monthOfYear)+" "+etC.dayOfMonth+", "+etC.year
    }

    private fun getTodayIndex(): Int {
        val etC = LocalDate(EthiopicChronology.getInstance())
        return etC.dayOfMonth
    }

    private fun setViewTexts(remoteViews: RemoteViews, context: Context) {
        if (getLang(context) == AM) {
            remoteViews.setTextViewText(R.id.txt_open_app, OPEN_APP_AM)
            remoteViews.setTextViewText(R.id.btn_change_lang, SELECTED_LAN_EN)
            remoteViews.setTextViewText(R.id.txt_title, TITLE_AM)

        } else {
            remoteViews.setTextViewText(R.id.txt_open_app, OPEN_APP_EN)
            remoteViews.setTextViewText(R.id.btn_change_lang, SELECTED_LAN_AM)
            remoteViews.setTextViewText(R.id.txt_title, TITLE_EN)

        }
    }

    private fun getLang(context: Context): String {
        shared = context.getSharedPreferences(MONTHLY_HOLIDAY_WIDGET_VALUES, Context.MODE_PRIVATE)
        var lang = shared.getString(CURRENT_LANG, AM)
        if (lang == null) return AM
        return lang
    }

    private fun setLang(context: Context, lan: String) {
        shared = context.getSharedPreferences(MONTHLY_HOLIDAY_WIDGET_VALUES, Context.MODE_PRIVATE)
        shared.edit().putString(CURRENT_LANG, lan).apply()
    }

    private fun getPendingSelfIntent(context: Context?, action: String?): PendingIntent? {
        val intent = Intent(context, javaClass)
        intent.action = action
        return PendingIntent.getBroadcast(context, 0, intent, 0)
    }

    open fun getMonthNameAm(month: Int): String? {
        var monthName: String? = null
        if (month == 1) {
            monthName = "መስከረም"
        } else if (month == 2) {
            monthName = "ጥቅምት"
        } else if (month == 3) {
            monthName = "ኅዳር"
        } else if (month == 4) {
            monthName = "ታኅሣሥ"
        } else if (month == 5) {
            monthName = "ጥር"
        } else if (month == 6) {
            monthName = "የካቲት"
        } else if (month == 7) {
            monthName = "መጋቢት"
        } else if (month == 8) {
            monthName = "ሚያዝያ"
        } else if (month == 9) {
            monthName = "ግንቦት"
        } else if (month == 10) {
            monthName = "ሰኔ"
        } else if (month == 11) {
            monthName = "ሐምሌ"
        } else if (month == 12) {
            monthName = "ነሐሴ"
        } else if (month == 13) {
            monthName = "ጳጉሜ"
        }
        return monthName
    }

    open fun getMonthNameEn(month: Int): String? {
        var monthName: String? = null
        if (month == 1) {
            monthName = "Jan"
        } else if (month == 2) {
            monthName = "Feb"
        } else if (month == 3) {
            monthName = "Mar"
        } else if (month == 4) {
            monthName = "Apr"
        } else if (month == 5) {
            monthName = "May"
        } else if (month == 6) {
            monthName = "Jun"
        } else if (month == 7) {
            monthName = "Jul"
        } else if (month == 8) {
            monthName = "Aug"
        } else if (month == 9) {
            monthName = "Sep"
        } else if (month == 10) {
            monthName = "Oct"
        } else if (month == 11) {
            monthName = "Nov"
        } else if (month == 12) {
            monthName = "Dec"
        }
        return monthName
    }

}