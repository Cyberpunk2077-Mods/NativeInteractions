local config = require("modules/utils/config")

local localization = {}
local configPath = "settings.json"
local uiText = require("modules/localization_zh")

local languages = {
    { code = "auto", name = "Follow game language" },
    { code = "ar-ar", name = "العربية" },
    { code = "cz-cz", name = "Čeština" },
    { code = "de-de", name = "Deutsch" },
    { code = "en-us", name = "English" },
    { code = "es-es", name = "Español" },
    { code = "es-mx", name = "Español (México)" },
    { code = "fr-fr", name = "Français" },
    { code = "hu-hu", name = "Magyar" },
    { code = "it-it", name = "Italiano" },
    { code = "jp-jp", name = "日本語" },
    { code = "kr-kr", name = "한국어" },
    { code = "pl-pl", name = "Polski" },
    { code = "pt-br", name = "Português (Brasil)" },
    { code = "ru-ru", name = "Русский" },
    { code = "th-th", name = "ไทย" },
    { code = "tr-tr", name = "Türkçe" },
    { code = "ua-ua", name = "Українська" },
    { code = "zh-cn", name = "简体中文" },
    { code = "zh-tw", name = "繁體中文" }
}

local strings = {
    ["en-us"] = { language = "Language", follow = "Follow game language", projects = "Projects", editProject = "Edit Project", editInteraction = "Edit Interaction", editRemovals = "Edit Removals", noProject = "No project loaded.", noInteraction = "No interaction loaded.", settings = "Settings" },
    ["ar-ar"] = { language = "اللغة", follow = "اتباع لغة اللعبة", projects = "المشاريع", editProject = "تحرير المشروع", editInteraction = "تحرير التفاعل", editRemovals = "تحرير الإزالات", noProject = "لم يتم تحميل مشروع.", settings = "الإعدادات" },
    ["cz-cz"] = { language = "Jazyk", follow = "Podle jazyka hry", projects = "Projekty", editProject = "Upravit projekt", editInteraction = "Upravit interakci", editRemovals = "Upravit odstranění", noProject = "Není načten žádný projekt.", settings = "Nastavení" },
    ["de-de"] = { language = "Sprache", follow = "Spielsprache verwenden", projects = "Projekte", editProject = "Projekt bearbeiten", editInteraction = "Interaktion bearbeiten", editRemovals = "Entfernungen bearbeiten", noProject = "Kein Projekt geladen.", settings = "Einstellungen" },
    ["es-es"] = { language = "Idioma", follow = "Usar idioma del juego", projects = "Proyectos", editProject = "Editar proyecto", editInteraction = "Editar interacción", editRemovals = "Editar eliminaciones", noProject = "No hay ningún proyecto cargado.", settings = "Ajustes" },
    ["es-mx"] = { language = "Idioma", follow = "Usar idioma del juego", projects = "Proyectos", editProject = "Editar proyecto", editInteraction = "Editar interacción", editRemovals = "Editar eliminaciones", noProject = "No hay ningún proyecto cargado.", settings = "Configuración" },
    ["fr-fr"] = { language = "Langue", follow = "Utiliser la langue du jeu", projects = "Projets", editProject = "Modifier le projet", editInteraction = "Modifier l’interaction", editRemovals = "Modifier les suppressions", noProject = "Aucun projet chargé.", settings = "Paramètres" },
    ["hu-hu"] = { language = "Nyelv", follow = "A játék nyelvének használata", projects = "Projektek", editProject = "Projekt szerkesztése", editInteraction = "Interakció szerkesztése", editRemovals = "Eltávolítások szerkesztése", noProject = "Nincs betöltött projekt.", settings = "Beállítások" },
    ["it-it"] = { language = "Lingua", follow = "Usa la lingua del gioco", projects = "Progetti", editProject = "Modifica progetto", editInteraction = "Modifica interazione", editRemovals = "Modifica rimozioni", noProject = "Nessun progetto caricato.", settings = "Impostazioni" },
    ["jp-jp"] = { language = "言語", follow = "ゲームの言語に合わせる", projects = "プロジェクト", editProject = "プロジェクト編集", editInteraction = "インタラクション編集", editRemovals = "削除設定", noProject = "プロジェクトが読み込まれていません。", settings = "設定" },
    ["kr-kr"] = { language = "언어", follow = "게임 언어 따르기", projects = "프로젝트", editProject = "프로젝트 편집", editInteraction = "상호작용 편집", editRemovals = "제거 항목 편집", noProject = "불러온 프로젝트가 없습니다.", settings = "설정" },
    ["pl-pl"] = { language = "Język", follow = "Użyj języka gry", projects = "Projekty", editProject = "Edytuj projekt", editInteraction = "Edytuj interakcję", editRemovals = "Edytuj usunięcia", noProject = "Nie wczytano projektu.", settings = "Ustawienia" },
    ["pt-br"] = { language = "Idioma", follow = "Usar idioma do jogo", projects = "Projetos", editProject = "Editar projeto", editInteraction = "Editar interação", editRemovals = "Editar remoções", noProject = "Nenhum projeto carregado.", settings = "Configurações" },
    ["ru-ru"] = { language = "Язык", follow = "Использовать язык игры", projects = "Проекты", editProject = "Изменить проект", editInteraction = "Изменить взаимодействие", editRemovals = "Изменить удаления", noProject = "Проект не загружен.", settings = "Настройки" },
    ["th-th"] = { language = "ภาษา", follow = "ใช้ภาษาของเกม", projects = "โปรเจกต์", editProject = "แก้ไขโปรเจกต์", editInteraction = "แก้ไขการโต้ตอบ", editRemovals = "แก้ไขการนำออก", noProject = "ไม่ได้โหลดโปรเจกต์", settings = "การตั้งค่า" },
    ["tr-tr"] = { language = "Dil", follow = "Oyun dilini kullan", projects = "Projeler", editProject = "Projeyi düzenle", editInteraction = "Etkileşimi düzenle", editRemovals = "Kaldırmaları düzenle", noProject = "Proje yüklenmedi.", settings = "Ayarlar" },
    ["ua-ua"] = { language = "Мова", follow = "Використовувати мову гри", projects = "Проєкти", editProject = "Редагувати проєкт", editInteraction = "Редагувати взаємодію", editRemovals = "Редагувати вилучення", noProject = "Проєкт не завантажено.", settings = "Налаштування" },
    ["zh-cn"] = { language = "语言", follow = "跟随游戏语言", projects = "项目", editProject = "编辑项目", editInteraction = "编辑交互", editRemovals = "编辑移除项", noProject = "未加载项目。", noInteraction = "未加载交互项。", settings = "设置" },
    ["zh-tw"] = { language = "語言", follow = "跟隨遊戲語言", projects = "專案", editProject = "編輯專案", editInteraction = "編輯互動", editRemovals = "編輯移除項", noProject = "未載入專案。", noInteraction = "未載入互動項目。", settings = "設定" }
}

local aliases = {
    ar = "ar-ar", cz = "cz-cz", cs = "cz-cz", de = "de-de", en = "en-us",
    es = "es-es", esmx = "es-mx", fr = "fr-fr", hu = "hu-hu", it = "it-it",
    ja = "jp-jp", jp = "jp-jp", ko = "kr-kr", kr = "kr-kr", pl = "pl-pl",
    ptbr = "pt-br", ru = "ru-ru", th = "th-th", tr = "tr-tr", uk = "ua-ua",
    ua = "ua-ua", zhcn = "zh-cn", zhtw = "zh-tw", simplifiedchinese = "zh-cn",
    traditionalchinese = "zh-tw"
}

local selected = "auto"
local active = "en-us"

local function normalize(value)
    value = tostring(value or ""):lower():gsub("_", "-")
    if strings[value] then return value end
    local compact = value:gsub("[^a-z]", "")
    return aliases[compact] or aliases[value:sub(1, 2)] or "en-us"
end

local function detectGameLanguage()
    local detected
    pcall(function()
        local variable = Game.GetSettingsSystem():GetVar("/language", "OnScreen")
        if variable then detected = variable:GetValue() end
    end)
    return normalize(detected)
end

function localization.init()
    config.tryCreateConfig(configPath, { language = "auto" })
    local settings = config.loadFile(configPath)
    selected = settings.language or "auto"
    if selected ~= "auto" and not strings[selected] then selected = "auto" end
    active = selected == "auto" and detectGameLanguage() or selected
end

function localization.get(key)
    return (strings[active] and strings[active][key]) or strings["en-us"][key] or key
end

function localization.text(value)
    return (uiText[active] and uiText[active][value]) or value
end

function localization.getLanguages()
    return languages
end

function localization.getSelected()
    return selected
end

function localization.setLanguage(code)
    selected = code
    active = code == "auto" and detectGameLanguage() or normalize(code)
    config.saveFile(configPath, { language = selected })
end

return localization
