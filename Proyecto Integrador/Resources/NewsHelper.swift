
class NewsHelper{

    private static let BASE_URL = "https://newsapi.org/v2/"
    private static let API_KEY = "142b284b913041e2a2523e7faaf1120c"

    private static let PARAM_API_KEY = "apikey=" + API_KEY
    private static let PARAM_SOURCES = "sources="
    private static let PARAM_DOMAINS = "domains="
    private static let PARAM_QUERY = "q="
    private static let PARAM_CATEGORY = "category="
    private static let PARAM_COUNTRY = "country="
    private static let PARAM_LANGUAGES = "language="
    private static let PARAM_SORT_BY = "sortBy="


    private static let RES_FUENTES = "sources"
    private static let RES_TOP = "top-headlines"
    private static let RES_EVERYTHING = "everything"


    private static let PAGE = "page="


    //SORT BY
    public static let sort_RELEVANCY = "relevancy"
    public static let sort_POPULARITY = "popularity"
    public static let sort_PUBLISHED_AT = "publishedAt"


    //IDIOMAS
    public static let language_ARABE = "ar"
    public static let language_INGLES = "en"
    public static let language_CHINO = "cn"
    public static let language_ALEMAN = "de"
    public static let language_ESPAÑOL = "es"
    public static let language_FRANCES = "fr"
    public static let language_HEBREO = "he"
    public static let language_ITALIANO = "it"
    public static let language_PAISES_BAJOS = "nl"
    public static let language_NORUEGO = "no"
    public static let language_PORTUGUES = "pt"
    public static let language_RUSO = "ru"
    public static let language_SUECO = "sv"

    //CATEGORIAS
    public static let category_BUSINESS = "business"
    public static let category_ENTERTAINMENT = "entertainment"
    public static let category_GAMING = "gaming"
    public static let category_GENERAL = "general"
    public static let category_HEALTH_AND_MEDICAL = "health-and-medical"
    public static let category_MUSIC = "music"
    public static let category_POLITICS = "politics"
    public static let category_SCIENCENATURE = "science-and-nature"
    public static let category_SPORT = "sport"
    public static let category_TECHNOLOGY = "technology"

    //PAISES
    public static let country_ARGENTINA = "ar"
    public static let country_AUSTRALIA = "au"
    public static let country_BRASIL = "br"
    public static let country_CANADA = "ca"
    public static let country_CHINA = "cn"
    public static let country_ALEMANIA = "de"
    public static let country_ESPANIA = "es"
    public static let country_FRANCIA = "fr"
    public static let country_GRANBRETANIA = "gb"
    public static let country_HONG_KONG = "hk"
    public static let country_IRLANDA = "ie"
    public static let country_INDIA = "in"
    public static let country_ISLANDIA = "is"
    public static let country_ITALIA = "it"
    public static let country_PAISES_BAJOS = "nl"
    public static let country_NORUEGA = "no"
    public static let country_PAKISTAN = "pk"
    public static let country_RUSIA = "ru"
    public static let country_ESTADOSUNIDOS = "us"


    //PEDIDOS ARTICULOS TOP
    public static func getTopHeadlinesPorFuente (idFuente: String) -> String {
    return  BASE_URL + RES_TOP + "?" + RES_FUENTES + idFuente + "&" + PARAM_API_KEY
    }

    public static func getTopheadlinesPorConsulta (searchQuery: String) -> String{
    return  BASE_URL + RES_TOP + "?" + PARAM_QUERY + searchQuery  + "&" + PARAM_API_KEY
    }

    public static func getTopheadlinesPorCategorias (categoryId: String) -> String{
    return  BASE_URL + RES_TOP + "?" + PARAM_CATEGORY + categoryId + "&" + PARAM_API_KEY
    }

    public static func getTopheadlinesPorIdioma (idioma: String) -> String{
    return  BASE_URL + RES_TOP + "?" + PARAM_LANGUAGES + idioma  + "&" + PARAM_API_KEY
    }

    public static func getTopheadlinesPorPais (pais: String) -> String{
    return  BASE_URL + RES_TOP + "?" + PARAM_COUNTRY + pais + "&" + PARAM_API_KEY
    }


    //PEDIDOS ARTICULOS EVERYTHING
    public static func getEverythingPorDominio (dominio: String) -> String{
    return  BASE_URL + RES_EVERYTHING + "?" + PARAM_DOMAINS + dominio + "&" + PARAM_API_KEY
    }

    public static func getEverythingPorFuente (idFuente: String) -> String{
    return  BASE_URL + RES_EVERYTHING + "?" + PARAM_SOURCES + idFuente + "&" + PARAM_API_KEY
    }

    public static func getEverythingPorConsulta (searchQuery: String) -> String{
    return  BASE_URL + RES_EVERYTHING + "?" + PARAM_QUERY + searchQuery  + "&" + PARAM_SORT_BY + sort_RELEVANCY + "&" + PARAM_API_KEY
    }

    public static func getEverythingPorConsultaNewest (searchQuery: String) -> String{
    return  BASE_URL + RES_EVERYTHING + "?" + PARAM_QUERY + searchQuery  + "&" + PARAM_SORT_BY + sort_PUBLISHED_AT + "&" + PARAM_API_KEY
    }

    public static func getEverythingPorConsultaPopular (searchQuery: String) -> String{
    return  BASE_URL + RES_EVERYTHING + "?" + PARAM_QUERY + searchQuery  + "&" + PARAM_SORT_BY + sort_POPULARITY + "&" + PARAM_API_KEY
    }



    //PEDIDOS FUENTES
    public static func getFuentes() -> String{
    return BASE_URL + RES_FUENTES + "?" + PARAM_API_KEY
    }

    public static func getFuentesPorCategoria (idCategoria: String) -> String{
    return BASE_URL + RES_FUENTES + "?" + PARAM_CATEGORY + idCategoria + "&" + PARAM_API_KEY
    }

    public static func getFuentesPorIdioma(idioma: String) -> String{
    return BASE_URL + RES_FUENTES + "?" + PARAM_LANGUAGES + idioma + "&" + PARAM_API_KEY
    }

    public static func getFuentesPorPais(pais: String) -> String{
    return BASE_URL + RES_FUENTES + "?" + PARAM_COUNTRY + pais + "&" + PARAM_API_KEY
    }
}
