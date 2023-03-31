-- タロットカードの意味をテーブルで定義
local cards = {
  {name = "愚者", upright = "旅立ち、自由、新しい始まり", reversed = "浪費、失敗、計画性の欠如"},
  {name = "魔術師", upright = "創造、才能、決断力", reversed = "不安定、自己中心的、イマジネーションの欠如"},
  {name = "魔術師", upright = "スキル、創造性、自信", reversed = "欠乏、自己欺瞞、未熟さ"},
  {name = "女教皇", upright = "知恵、啓示、直感", reversed = "無知、秘密主義、誤解"},
  {name = "女帝", upright = "母性、豊かさ、愛", reversed = "依存、虚栄心、対立"},
  {name = "皇帝", upright = "支配、自信、責任感", reversed = "支配欲、暴君、無責任"},
  {name = "教皇", upright = "伝統、信仰、知識", reversed = "偽善、閉鎖性、保守主義"},
  {name = "恋愛", upright = "愛、情熱、調和", reversed = "不倫、不和、嫉妬"},
  {name = "戦車", upright = "勝利、自信、意志", reversed = "敗北、自己破壊、激情的"},
  {name = "力", upright = "強さ、調和、自信", reversed = "自己中心的、弱さ、不和"},
  {name = "隠者", upright = "孤独、冷静、自己探求", reversed = "孤立、不安、隠蔽"},
  {name = "運命の輪", upright = "転換点、運命、進展", reversed = "停滞、失われた機会、混乱"},
  {name = "正義", upright = "正義、公正、道徳", reversed = "偏見、不公正、腐敗"},
  {name = "吊るされた男", upright = "犠牲、懸念、奉仕", reversed = "エゴイズム、無駄な犠牲、自傷"},
  {name = "死神", upright = "転換、変化、成長", reversed = "停滞、堕落、停止"},
  {name = "節制", upright = "節度、バランス、中庸", reversed = "過剰、浪費、自己中心的"},
  {name = "悪魔", upright = "束縛、不道徳、堕落", reversed = "解放、自由、心の平静"},
  {name = "塔", upright = "崩壊、破壊、激変", reversed = "回復、再生、再構築"},
  {name = "星", upright = "希望、安心、調和", reversed = "不安、失望、妄想"},
  {name = "月", upright = "不安定、混乱、非現実的", reversed = "安定、直感、クリエイティブ"},
  {name = "太陽", upright = "幸福、光、豊かさ", reversed = "劣化、鬱、浅はかさ"},
  {name = "審判", upright = "転換、決定、復活", reversed = "拒絶、決着、終焉"},
  {name = "世界", upright = "完成、到達、成就", reversed = "未完成、途中放棄、不十分"},
}

-- ランダムに2枚のカードを選ぶ
local card1 = cards[math.random(#cards)]
local card2 = cards[math.random(#cards)]

-- カードの正位置か逆位置をランダムに選ぶ
local upright1 = math.random(2) == 1
local upright2 = math.random(2) == 1

-- カードの正位置と逆位置でそれぞれの意味を取得する関数
local function get_card_meaning(card, upright)
  if upright then
    return card.upright
  else
    return card.reversed
  end
end

-- カードの組み合わせと意味を表示する
reaper.ShowMessageBox(
  "あなたのカードは\n\n" ..
  card1.name .. (upright1 and "（正位置）" or "（逆位置）") .. "と\n" ..
  card2.name .. (upright2 and "（正位置）" or "（逆位置）") .. "です。\n\n" ..
  "1枚目のカードの意味：\n" ..
  get_card_meaning(card1, upright1) .. "\n\n" ..
  "2枚目のカードの意味：\n" ..
  get_card_meaning(card2, upright2),
  "タロットカードの組み合わせ",
  0)

