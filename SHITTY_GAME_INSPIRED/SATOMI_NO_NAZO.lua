function generateRandomName()
    local name = ""
    local kana = {
        "あ", "い", "う", "え", "お",
        "か", "き", "く", "け", "こ",
        "さ", "し", "す", "せ", "そ",
        "た", "ち", "つ", "て", "と",
        "な", "に", "ぬ", "ね", "の",
        "は", "ひ", "ふ", "へ", "ほ",
        "ま", "み", "む", "め", "も",
        "や", "ゆ", "よ",
        "ら", "り", "る", "れ", "ろ",
        "わ", "を", "ん",
        "が", "ぎ", "ぐ", "げ", "ご",
        "ざ", "じ", "ず", "ぜ", "ぞ",
        "だ", "ぢ", "づ", "で", "ど",
        "ば", "び", "ぶ", "べ", "ぼ",
        "ゐ", "ゑ",
        "ゅ","ゃ","っ","ょ",
        "ぁ","ぃ","ぅ","ぇ","ぉ"


    }
    for i = 1, 5 do
        local index = math.random(#kana)
        name = name .. kana[index]
    end
    return name
end


function setNameToSelectedTracks()
  for i=0, reaper.CountSelectedTracks(0)-1 do
    local track = reaper.GetSelectedTrack(0, i)
    local name = generateRandomName()
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", name, true)
  end
end

function main()
  reaper.Undo_BeginBlock()
  setNameToSelectedTracks()
  reaper.Undo_EndBlock("Random name to selected tracks", -1)
end

main()

