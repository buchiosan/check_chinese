require 'csv'

CODEPOINTS =
{
    japanese_kun: File.read('japanese_kun'),
    japanese_on:  File.read('japanese_on'),
    cantonese:    File.read('cantonese'),
    mandarin:     File.read('mandarin'),
}.freeze

# size == 1のStringをcodepointに変換する
def to_codepoint(character)
#raise "size == 1のStringを与える必要がある" unless character.size == 1
character.codepoints.map{|cp| sprintf("%04X", cp)}.first
end

# 以下のように書きたいところだが重いので正規表現でやる
# CODEPOINTS[:japanese_kun].include?(codepoint) # (CODEPOINTS[:japanese_kun]を配列にしておいた上で)
def japanese_kun?(codepoint)
!!(CODEPOINTS[:japanese_kun] =~ /\nU\+#{codepoint}\n/)
end

def japanese_on?(codepoint)
!!(CODEPOINTS[:japanese_on] =~ /\nU\+#{codepoint}\n/)
end

def cantonese?(codepoint)
    !!(CODEPOINTS[:cantonese] =~ /\nU\+#{codepoint}\n/)
end

def mandarin?(codepoint)
    !!(CODEPOINTS[:mandarin] =~ /\nU\+#{codepoint}\n/)
end

# 漢字か判定
def han?(character)
    character =~ /\p{Han}/
end

# 文字列から中国語らしき文字をselectする。
# なぜか漢字以外のcodepointを与えると期待した動作をしないので、漢字のみで判定する。
def select_chinese_and_not_japanese(survey_target_string)
    survey_target_string.split('').select do |character|
        next if !han?(character)

        codepoint = to_codepoint(character)
        next if japanese_kun?(codepoint) || japanese_on?(codepoint)
        next if !(cantonese?(codepoint) || mandarin?(codepoint))

        true
    end
end

# $data = File.read('data.txt')

# $array = $data.split("\n")
# p select_chinese_and_not_japanese('<h3><b>【商品名称动】</b></h3><p>ピジョン　レンジで蒸しパン ほうれん草＆小松菜</p><br><h3><b>【商品概要】</b></h3><p>牛乳を入れレンジで加熱するだけで作れる蒸しパン粉ベビーフード(9ヶ月頃から)です。カップに牛乳とミックス粉を入れ、レンジで加熱するだけ。かんたんにふんわり蒸しパンが作れます(牛乳のかわりに水・育児用ミルクでも作れます)。着色料・香料・保存料不使用。</p><br><h3><b>【使用方法】</b></h3><p>●作り方<br>(1)本品1袋と牛乳または水15ml(計量スプーン大さじ1杯)を付属のカップに入れます。<br>※育児用ミルクで作る場合は、ミルクに表示されている(ミルクの溶かし方)に従って作り、人肌程度に冷ましてからお使いください。<br>※熱した牛乳・熱湯は使用しないでください。<br>(2)ハシ2本で円を描くように30回程度混ぜます。粉・ダマが多少あってもOK。<br>※混ぜすぎると粘りが出て、蒸しパンの食感が悪くなります。<br>(3)電子レンジで加熱します。(ラップは不要)。<br>※加熱が終わると、ふくらみがややしぼみます。<br>※冷ますときは、乾燥しないようカップごとラップで包んでください。<br><br>●加熱時間の目安(1個分)<br>500W/牛乳・ミルクで作る:50秒、水で作る:60秒<br>600W/牛乳・ミルクで作る:40秒、水で作る:50秒<br>※加熱直後はカップが熱くなっていますのでヤケドにご注意ください。<br>※加熱のしすぎは、発火やぱさついたり固くなる原因となります。<br>※電子レンジの機種により加熱時間が多少異なります。<br>※電子レンジのオート(自動)機能や700W以上での調理はおやめください。<br>※1個ずつ加熱してください。</p><br><h3><b>【商品特徴】</b></h3><p>【毎日のおやつや朝食にぴったり！】<br>お子さまに与えたい素材を使った甘さひかえめのかんたん蒸しパンです。<br>■お子さまに与えたい素材を使用<br>　お子様に与えたい野菜や果物などの素材を使ったおいしい蒸しパンです。<br>■甘さひかえめ　甘さひかえめなので素材の味が楽しめます。<br>■レンジでかんたん<br>　牛乳を入れてまぜてレンジでチン！<br>　約40秒でふんわり蒸しパンができあがります。<br>■取っ手付きのカップ<br>　取っ手付きのカップで、レンジで温めた後にも持ちやすく、<br>　手で切れるのでお皿に出してお子さまにとりわけやすくなりました。</p><br><h3><b>【注意事項】</b></h3><p>●カップが空の状態では絶対に加熱しないでください。<br>●思わぬ事故を防ぐため、お子さまがカップをかじったり、カップの切れ端が誤ってお子さまの口に入らないようにご注意ください。<br>●小さなお子様は、必ず大人の方と一緒におつくり下さい。<br>●一度使用したカップは繰り返し使用しないでください。</p><br><h3><b>【規格】</b></h3><p>2食入り</p><br><h3><b>【主要成分】</b></h3><p>砂糖、小麦でん粉、植物油脂、小麦粉、脱脂粉乳、卵黄粉末、デキストリン、コーンシロップ、グリーンピース粉末、ほうれん草粉末、食用卵殻粉、食物繊維、小松菜粉末、食塩、加工でん粉、膨張剤、増粘剤（グァー）、酸化防止剤（ビタミンE）、（原材料の一部に大豆を含む）</p>')
# cnti = 0
file = File.open('result1.txt',"w")
arr_of_arrs = CSV.read("kensakucsv.csv")

arr_of_arrs.each_with_index do |row, i|
    result = select_chinese_and_not_japanese(row.to_s)
    file.puts("#{i+ 1},#{result}")
end

# CSV.foreach("kensakucsv.csv") do |row|
#     p select_chinese_and_not_japanese(row)
# end