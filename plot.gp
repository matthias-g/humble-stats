reset
#set term pdf size 12,3
set term png noenhanced size 1300,400 font DejaVuSans 10
#set output "output.pdf"
set output "~/html/graphs/humble/".bundle.".png"

set xdata time
set timefmt "%s"
set format x "%d.%m. %H:%M"
set xlabel "time"

set key left top

set datafile commentschars "#!%"

delta_v(x) = ( vD = x - old_v, old_v = x, vD)
delta_t(x) = ( tD = x - old_t, old_t = x, tD)
old_v = NaN
old_t = NaN

set title bundle
set style data lines
set y2tics

init(x) = (back1 = back2 = back3 = back4 = back5 = back6 = back7 = back8 = back9 = back10 = back11 = back12 = back13 = back14 = back15 = sum = 0)
samples5(x) = $0 > 4 ? 5 : ($0+1)
samples10(x) = $0 > 9 ? 10 : ($0+1)
samples15(x) = $0 > 14 ? 15 : ($0+1)
avg5(x) = (shift5(x), (back1+back2+back3+back4+back5)/samples5($0))
shift5(x) = (back5 = back4, back4 = back3, back3 = back2, back2 = back1, back1 = x)
avg10(x) = (shift10(x), (back1+back2+back3+back4+back5+back6+back7+back8+back9+back10)/samples10($0))
shift10(x) = (back10 = back9, back9 = back8, back8 = back7, back7 = back6, back6 = back5, back5 = back4, back4 = back3, back3 = back2, back2 = back1, back1 = x)
avg15(x) = (shift15(x), (back1+back2+back3+back4+back5+back6+back7+back8+back9+back10+back11+back12+back13+back14+back15)/samples15($0))
shift15(x) = (back15 = back14, back14 = back13, back13 = back12, back12 = back11, back11 = back10, back10 = back9, back9 = back8, back8 = back7, back7 = back6, back6 = back5, back5 = back4, back4 = back3, back3 = back2, back2 = back1, back1 = x)


plot sum = init(0), "stats/".bundle using 2:1 title 'price', \
	'' using 2:(60 * avg10(delta_v($4) / delta_t($2))) title 'purchases' axes x1y2

